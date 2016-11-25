//
//  TTGridCell.m
//  TTGridCell
//
//  Created by tanson on 2016/11/24.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import "TTGridCell.h"

const static CGFloat ItemHeight = 70;
const static CGFloat ItemSpace  = 0.5; //间隔

const static CGFloat Icon_Space_Title = 2;

#define ScreentSize [UIScreen mainScreen].bounds.size
#define TitleFont [UIFont systemFontOfSize:12]


#pragma mark- TTGridCellItem

@implementation TTGridCellModel

-(instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName{
    
    if([super initWithFrame:CGRectZero]){
        _title = title;
        _iconName = iconName;
        [self setupView];
    }
    return self;
}

-(UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = TitleFont;
        _titleLab.text = self.title;
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

-(UIImageView *)imageView{
    if(!_imageView){
        UIImage * image = [UIImage imageNamed:self.iconName];
        _imageView = [[UIImageView alloc] initWithImage:image];
    }
    return _imageView;
}

-(void)setupView{
    [self addSubview:self.titleLab];
    [self addSubview:self.imageView];
    CGSize imageSize = self.imageView.image.size;
    CGSize labSize = self.titleLab.frame.size;
    self.frame = CGRectMake(0, 0, labSize.width, imageSize.height + labSize.height + Icon_Space_Title);
    
    self.titleLab.layer.anchorPoint = CGPointMake(0.5, 1);
    self.titleLab.layer.position = CGPointMake(self.frame.size.width/2,self.frame.size.height);
    
    self.imageView.layer.anchorPoint = CGPointMake(0.5, 0);
    self.imageView.layer.position = CGPointMake(self.frame.size.width/2, 0);
}

@end


#pragma mark- TTGridCell

@interface TTGridCell ()
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) NSArray * models;
@property (nonatomic,assign) NSInteger colNum;
@property (nonatomic,strong) NSArray * itemViews;
@property (nonatomic,assign) NSInteger curTouchIndex;

@end

@implementation TTGridCell

-(instancetype)initWithModels:(NSArray<TTGridCellModel *> *)models colNum:(NSInteger)colNum{
    if([super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""]){
        _models = models;
        _colNum = colNum;
        _curTouchIndex = -1;
        [self setupView];
    }
    return self;
}

-(CGFloat)cellHeight{
    int rows =  ceil(self.models.count / (CGFloat)self.colNum);
    return rows * ItemHeight + (rows-1)*ItemSpace;
}


- (void)setupView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    int rows =  ceil(self.models.count / (CGFloat)self.colNum);
    NSMutableArray * itemViews = @[].mutableCopy;
    
    for(int i=0;i< rows * self.colNum;++i){
        CGRect frame = [self frameForItemAtIndex:i];
        
        UIView * itemView = [[UIView alloc] initWithFrame:frame];
        itemView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:itemView];
        [itemViews addObject:itemView];
        
        if( i < self.models.count){
            TTGridCellModel * model = self.models[i];
            [itemView addSubview:model];
            model.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        }
        
        self.itemViews = itemViews;
    }
}

- (CGRect) frameForItemAtIndex:(NSInteger)index{
    NSInteger row = index / self.colNum;
    NSInteger col = index % self.colNum;
    CGFloat itemWidth = (ScreentSize.width - (self.colNum-1)*ItemSpace) / self.colNum;
    CGFloat x = col * (ItemSpace + itemWidth);
    CGFloat y = row * (ItemSpace + ItemHeight);
    return CGRectMake(x, y, itemWidth, ItemHeight);
}

- (NSInteger) indexForItemByPoint:(CGPoint)point{
    
    __block NSInteger index = -1;
    [self.itemViews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL * stop) {
        if( CGRectContainsPoint(view.frame, point)){
            index = idx;
            *stop = YES;
        }
    }];
    return index < self.models.count? index:-1 ;
}

#pragma mark- touch event

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.contentView];
    NSInteger index = [self indexForItemByPoint:point];
    if(index >= 0 ){
        UIView * hitView = self.itemViews[index];
        hitView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.curTouchIndex = index;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.curTouchIndex < 0){
        return;
    }
    
    UIView * touchView = self.itemViews[self.curTouchIndex];
    [UIView animateWithDuration:0.3 animations:^{
        touchView.backgroundColor = [UIColor whiteColor];
    }];
    
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.contentView];
    NSInteger index = [self indexForItemByPoint:point];
    if(index == self.curTouchIndex){
        self.itemTouchHandler? self.itemTouchHandler(index):nil;
    }
    self.curTouchIndex = -1;
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.curTouchIndex < 0){
        return;
    }
    UIView * touchView = self.itemViews[self.curTouchIndex];
    [UIView animateWithDuration:0.3 animations:^{
        touchView.backgroundColor = [UIColor whiteColor];
    }];
    self.curTouchIndex = -1;
}

@end


