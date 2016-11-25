//
//  TTGridCell.h
//  TTGridCell
//
//  Created by tanson on 2016/11/24.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TTGridCellItemTouchHandler)(NSInteger index);

@interface TTGridCellModel : UIView
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * iconName;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIImageView * imageView;
-(instancetype) initWithTitle:(NSString*)title iconName:(NSString*)iconName;
@end

#pragma mark- TTGridCell

@interface TTGridCell : UITableViewCell

@property (nonatomic,assign,readonly) CGFloat cellHeight;
@property (nonatomic,copy) TTGridCellItemTouchHandler itemTouchHandler;

// 默认 tableView width == screent width
-(instancetype) initWithModels:(NSArray<TTGridCellModel*> *)models colNum:(NSInteger)colNum;

@end
