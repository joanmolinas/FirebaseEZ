//
//  FEZDatabaseConnector.h
//  FirebaseEZ
//
//  Created by Joan Molinas Ramon on 29/12/16.
//  Copyright © 2016 NSBeard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEZManager.h"

typedef NS_ENUM(NSInteger, FEZDatabaseEvent) {
    FEZDatabaseEventAddedObject = 0,
    FEZDatabaseEventRemovedObject,
    FEZDatabaseEventChangedObject,
    FEZDatabaseEventMovedObject
};

@class FEZDatabaseConnector;
@protocol FEZDatabaseConnectorDelegate
@optional
- (void)databaseConnector:(FEZDatabaseConnector *)databaseConnector
          didAddNewObject:(id)object;
@optional
- (void)databaseConnector:(FEZDatabaseConnector *)databaseConnector
          didRemoveObject:(id)object;
@optional
- (void)databaseConnector:(FEZDatabaseConnector *)databaseConnector
          didChangedObject:(id)object;
@optional
- (void)databaseConnector:(FEZDatabaseConnector *)databaseConnector
          didMovedObject:(id)object;
@end

@interface FEZDatabaseConnector : NSObject

@property (nonatomic, strong, readonly) NSString *databaseName;
@property (nonatomic, weak) id<FEZDatabaseConnectorDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableArray *objects;

- (instancetype)initWithDatabaseName:(NSString *)databaseName;


- (void)observeWithType:(FEZDatabaseEvent)type;
- (void)dropWithType:(FEZDatabaseEvent)type;
@end
