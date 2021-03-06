//
//  CollectionViewCell.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ==========================================
//  The primary CollectionViewCell with a full
//  background image and text over it.
//  This handles its own image cropping.
//  ==========================================

@class BaseEntity;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) CGFloat yPadding;

- (UIImage*)cropImage:(UIImage*)image;
- (void)setImageForEntity:(BaseEntity*)entity;

@end
