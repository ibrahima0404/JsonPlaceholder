//
//  CoreDataContainer.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 03/11/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataContainer : NSObject
@property(nonatomic, strong, readonly) NSPersistentContainer *container;
+(CoreDataContainer*)sharedCoreDataContainer;
@end

NS_ASSUME_NONNULL_END
