//
//  BBNetworkAgent.m
//  BBNetWork
//
//  Created by Gary on 4/25/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "BBNetworkAgent.h"

#import "BBNetworkConfig.h"
#import "BBNetworkPrivate.h"
#import <MPMessagePack/MPMessagePack.h>
#import "NSData+BBNGZIP.h"
#import "AFGzipRequestSerializer.h"
#import "AFGzipResponseSerializer.h"
#import "BBAppDotNetAPIClient.h"

@implementation BBNetworkAgent {
    
    BBNetworkConfig *_config;
    NSMutableDictionary *_requestsRecord;
}

+ (BBNetworkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _config = [BBNetworkConfig sharedInstance];
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)buildRequestUrl:(BBBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<BBUrlFilterProtocol> f in filters) {
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }
    
    NSString *baseUrl;
    if ([request useCDN]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        } else {
            baseUrl = [_config baseUrl];
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (void)addRequest:(BBBaseRequest *)request {
    AFHTTPSessionManager *manager = [BBAppDotNetAPIClient sharedClient];
    manager.operationQueue.maxConcurrentOperationCount = 4;
    manager.securityPolicy = _config.securityPolicy;

    BBRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;
    //参数添加编码
    if ([param isKindOfClass:[NSString class]]) {
        param = [BBNetworkPrivate urlEncode:param];
    }
    else if ([param isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *tempParamDic = [NSMutableDictionary dictionaryWithDictionary:param];
        for (NSString *key in param) {
            if ([param[key] isKindOfClass:[NSString class]]) {
                NSString *value = param[key];
                // value = [BBNetworkPrivate urlEncode:value];
                [tempParamDic setObject:value forKey:key];
            };
           
        }
        param = [NSDictionary dictionaryWithDictionary:tempParamDic];
    }
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    //请求
    if (request.requestSerializerType == BBRequestSerializerTypeHTTP) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == BBRequestSerializerTypeJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else if (request.requestSerializerType == BBRequestSerializerTypeMsgPack) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == BBRequestSerializerTypeGzip) {
        manager.requestSerializer = [AFGzipRequestSerializer serializerWithSerializer:[AFJSONRequestSerializer serializer]];
    }
    //返回
    if (request.responseSerializerType == BBResponseSerializerTypeHTTP) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    else if (request.responseSerializerType == BBResponseSerializerTypeJSON) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    else if (request.responseSerializerType == BBResponseSerializerTypeGzip) {
        manager.responseSerializer = [AFGzipResponseSerializer serializer];
    }
    
    manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                BBNLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    BBNLog(@"header - %@\n url - %@\n param - %@", headerFieldValueDictionary, url, param);
    // request.requestOperation 部分功能缺失
    if (method == BBRequestMethodGet) {
        request.sessionDataTask = [manager GET:url
                                     parameters:param
                                       progress:NULL
                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                            [self handleRequestResult:task responseObject:responseObject error:nil];
                                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            [self handleRequestResult:task responseObject:nil error:error];
                                        }];
    } else if (method == BBRequestMethodPost) {
        if (constructingBlock != nil) {
            request.sessionDataTask = [manager POST:url
                                          parameters:param
                           constructingBodyWithBlock:constructingBlock
                                            progress:^(NSProgress * _Nonnull uploadProgress) {
                                                
                                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                       {
                                           [self handleRequestResult:task responseObject:responseObject error:nil];
                                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                       {
                                           [self handleRequestResult:task responseObject:nil error:error];
                                       }];
        } else {
            request.sessionDataTask = [manager POST:url
                                          parameters:param
                                            progress:^(NSProgress * _Nonnull uploadProgress) {
                                                
                                            }
                                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                       {
                                           [self handleRequestResult:task responseObject:responseObject error:nil];
                                       }
                                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                       {
                                           [self handleRequestResult:task responseObject:nil error:error];
                                       }];
        }
    } else if (method == BBRequestMethodHead) {
        request.sessionDataTask = [manager HEAD:url
                                      parameters:param
                                         success:^(NSURLSessionDataTask * _Nonnull task)
                                   {
                                       [self handleRequestResult:task responseObject:nil error:nil];
                                   }
                                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                   {
                                       [self handleRequestResult:task responseObject:nil error:error];
                                   }];
    } else if (method == BBRequestMethodPut) {
        request.sessionDataTask = [manager PUT:url
                                     parameters:param
                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                   {
                                       [self handleRequestResult:task responseObject:responseObject error:nil];
                                   }
                                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                   {
                                       [self handleRequestResult:task responseObject:nil error:error];
                                   }];
    } else if (method == BBRequestMethodDelete) {
        request.sessionDataTask = [manager DELETE:url
                                        parameters:param
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                   {
                                       [self handleRequestResult:task responseObject:responseObject error:nil];
                                   }
                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                   {
                                       [self handleRequestResult:task responseObject:nil error:error];
                                   }];
    } else if (method == BBRequestMethodPatch) {
        request.sessionDataTask = [manager PATCH:url
                                       parameters:param
                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                   {
                                       [self handleRequestResult:task responseObject:responseObject error:nil];
                                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                   {
                                       [self handleRequestResult:task responseObject:nil error:error];
                                   }];
    } else {
        BBNLog(@"Error, unsupport method type");
        return;
    }
    
    
    BBNLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
}

- (void)cancelRequest:(BBBaseRequest *)request {
    [request.sessionDataTask cancel];
    [self removeOperation:request.sessionDataTask];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        BBBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

- (BOOL)checkResult:(BBBaseRequest *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
        id json = [request responseObject];
        result = [BBNetworkPrivate checkJson:json withValidator:validator];
    }
    return result;
}
#pragma mark - 处理返回结果

- (void)handleRequestResult:(NSURLSessionDataTask *)sessionDataTask
             responseObject:(id)responseObject
                      error:(NSError *)error {
    NSString *key = [self requestHashKey:sessionDataTask];
    BBBaseRequest *request = _requestsRecord[key];
    BBNLog(@"Finished Request: %@", NSStringFromClass([request class]));
    id object = responseObject;
    request.error = error;
    if (request.responseSerializerType == BBResponseSerializerTypeHTTP) {
        //http
        //检测是否需要GZIP解压缩
        NSString *contentEncoding = [[(NSHTTPURLResponse *)sessionDataTask.response allHeaderFields] objectForKey:@"Content-Type"];
        if ([contentEncoding containsString:@"x-tf-gzip-json"]) {
            //gzip 解压缩
            NSError *compressionError = nil;
            object = [responseObject dataByGZipDecompressingDataWithError:&compressionError];
        }
    }
    if (request.responseSerializerType == BBResponseSerializerTypeMsgPack) {
        NSError *error = nil;
        //解析msg pack
        request.responseObject = [MPMessagePackReader readData:object error:&error];
        if (error) {
            request.responseObject = responseObject;
        }
    }
    else {
        if ([object isKindOfClass:[NSDictionary class]]) {
            request.responseObject = object;
        }else if ([object isKindOfClass:[NSData class]]) {
            request.responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
    }
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil) {
                [request.delegate requestFinished:request];
            }
            if ([BBNetworkConfig sharedInstance].commonCompletionBlock) {
                [BBNetworkConfig sharedInstance].commonCompletionBlock(request);
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        } else {
            BBNLog(@"Request %@ failed, status code = %ld",
                   NSStringFromClass([request class]), (long)request.responseStatusCode);
            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil) {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeOperation:sessionDataTask];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(NSURLSessionDataTask *)sessionDataTask {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[sessionDataTask hash]];
    return key;
}

- (void)addOperation:(BBBaseRequest *)request {
    if (request.sessionDataTask != nil) {
        NSString *key = [self requestHashKey:request.sessionDataTask];
        @synchronized(self) {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeOperation:(NSURLSessionDataTask *)sessionDataTask {
    NSString *key = [self requestHashKey:sessionDataTask];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
    BBNLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

@end
