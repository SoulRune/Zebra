//
//  ZBQueueViewController.h
//  Zebra
//
//  Created by Wilson Styres on 1/30/19.
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

#import "ZBTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBQueueViewController : ZBTableViewController
- (id)init;
- (void)refreshTable;
@property (nonatomic, weak) UISheetPresentationController *sheetController;
@end

NS_ASSUME_NONNULL_END
