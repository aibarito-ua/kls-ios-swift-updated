//
//  KollusPlayerLMSDelegate.h
//  KollusSDK
//
//  Created by Franky.Jung on 2014. 12. 4..
//  Copyright (c) 2014년 Catenoid. All rights reserved.
//

#import "KollusSDK.h"

@protocol KollusPlayerLMSDelegate <NSObject>

/**
 LMS정보를 서버로 전송후 호출
 @param kollusPlayerView KollusPlayerView 아이디
 @param json 리퀘스트로 보낸 JSON 객체
 @param error 네트워크 에러(nil: 성공)
 */
- (void)kollusPlayerView:(KollusPlayerView *)kollusPlayerView json:(NSDictionary *)json error:(NSError *)error;

@end