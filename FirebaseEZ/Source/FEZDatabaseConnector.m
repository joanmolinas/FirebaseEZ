//
//  FEZDatabaseConnector.m
//  FirebaseEZ
//
//  Created by Joan Molinas Ramon on 29/12/16.
//  Copyright © 2016 NSBeard. All rights reserved.
//

#import "FEZDatabaseConnector.h"

@interface FEZDatabaseConnector ()
@property (nonatomic, strong) FIRDatabaseReference *reference;
@property (nonatomic, assign) FIRDatabaseHandle addedHandler;
@property (nonatomic, assign) FIRDatabaseHandle removedHandler;
@property (nonatomic, assign) FIRDatabaseHandle changedHandler;
@property (nonatomic, assign) FIRDatabaseHandle movedHandler;
@end

@implementation FEZDatabaseConnector

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    if (self = [super init]) {
        NSAssert([FEZManager sharedManager].configured, @"Configure FEZManager first");
        _databaseName = databaseName;
        _reference = [[FIRDatabase database] reference];
        _objects = [NSMutableArray new];
    }
    
    return self;
}

- (void)observeWithType:(FEZDatabaseEvent)type {
    switch (type) {
        case FEZDatabaseEventAddedObject:
            self.addedHandler = [self _observeEventTypeChildAdded];
            break;
        case FEZDatabaseEventRemovedObject:
            self.removedHandler = [self _observeEventTypeChildRemoved];
            break;
        case FEZDatabaseEventChangedObject:
            self.changedHandler = [self _observeEventTypeChildChanged];
            break;
        case FEZDatabaseEventMovedObject:
            self.movedHandler = [self _observeEventTypeChildMoved];
            break;
        default:
            break;
    }
}

- (void)dropWithType:(FEZDatabaseEvent)type {
    FIRDatabaseHandle handler;
    switch (type) {
        case FEZDatabaseEventAddedObject:
            handler = self.addedHandler;
            break;
        case FEZDatabaseEventRemovedObject:
            handler = self.removedHandler;
            break;
        case FEZDatabaseEventChangedObject:
            handler = self.changedHandler;
            break;
        case FEZDatabaseEventMovedObject:
            handler = self.movedHandler;
            break;
        default:
            break;
    }
    [self.reference removeObserverWithHandle:handler];
}


#pragma mark - Private Api
- (FIRDatabaseHandle)_observeEventTypeChildAdded {
    __weak typeof(self)weakSelf = self;
    FIRDatabaseHandle handle = [[self.reference child:_databaseName] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.objects addObject:snapshot.value];
        [strongSelf.delegate databaseConnector:strongSelf didAddNewObject:snapshot.value];
    }];
    
    return handle;
}
- (FIRDatabaseHandle)_observeEventTypeChildRemoved {
    __weak typeof(self)weakSelf = self;
    FIRDatabaseHandle handle = [[self.reference child:_databaseName] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.objects removeObject:snapshot.value];
        [strongSelf.delegate databaseConnector:strongSelf didRemoveObject:snapshot.value];
    }];
    
    return handle;
}

- (FIRDatabaseHandle)_observeEventTypeChildChanged {
    __weak typeof(self)weakSelf = self;
    FIRDatabaseHandle handle = [[self.reference child:_databaseName] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.delegate databaseConnector:strongSelf didChangedObject:snapshot.value];
    }];
    
    return handle;
}

- (FIRDatabaseHandle)_observeEventTypeChildMoved {
    __weak typeof(self)weakSelf = self;
    FIRDatabaseHandle handle = [[self.reference child:_databaseName] observeEventType:FIRDataEventTypeChildMoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.delegate databaseConnector:strongSelf didMovedObject:snapshot.value];
    }];
    
    return handle;
}

@end
