//
// implement private method in ApiClient class
//

- (void)sendRequest:(NSURLRrequest *)request successBlock:(void (^)(AFHTTPRequestOperation *operation, id responsObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    __block NSUInteger numberOfRetries = 3;
    __block __weak void (^weakSendRequest)(void);
    void (^sendRequestBlock)(void);
    weakSendRequestBlock = sendRequestBlock = ^{
        __strong typeof (weakSendRequestBlock)strongSendRequestBlock = weakSendRequestBlock;
        numberOfRetries--;

        AFHTTPRequestOperation *operation = [self.httpManager HTTPRequestOperationWithRequest:request success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSInteger statusCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailureURLResponseErrorKey] statusCode];

            if (numberOfRetries > 0 && (statusCode == 500 || statusCode == 502 || statusCode == 503 || statusCode == 0)) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    strongSendRequestBlock();
                });
            } else {
                if (failureBlock) {
                    failureBlock(operation, error);
                }
            }
        }];

        [self.httpManager.operationQueue addOperation:operation];
    };

    sendRequestBlock();
}
