//
//  GearSdk
//
//  Created by xzs on 2024/5/9.
//

#import <Foundation/Foundation.h>

@interface GearSDK : NSObject

+ (void)setAgreePrivacy:(BOOL)isAgree;

+ (void)showGearView;

+ (void)showGearViewxPos:(int)xPos yPos:(int)yPos;

+ (void)hideGearView;

+ (void)configMaxSpeedIndex:(int)maxSpeedIndex maxGear:(int)maxGear;

+ (void)start;

+ (void)stop;

+ (void)speedUp:(int)speedIndex;

+ (void)speedDown:(int)speedIndex;

@end
