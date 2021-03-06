//
//  CollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "CollectionViewCell.h"
#import "BaseEntity.h"
#import <NYXImagesKit/NYXImagesKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CollectionViewCell ()
@property (nonatomic, assign) CGFloat xPadding;
@end

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _xPadding = 10;
        _yPadding = 10;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                       CGRectGetWidth(self.frame),
                                                                       CGRectGetHeight(self.frame))];
        _imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:_imageView];
        
        // Text gradient (so the text is readable)
        UIView *textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                            CGRectGetWidth(self.frame),
                                                                            CGRectGetHeight(self.frame))];
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = textGradientView.bounds;
        textGradient.colors = @[ (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor blackColor] CGColor] ];
        [textGradientView.layer addSublayer:textGradient];
        textGradientView.alpha = 0.7;
        [self addSubview:textGradientView];
        
        CGFloat textLabelHeight = 120;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_xPadding,
                                                                   CGRectGetHeight(self.frame) - textLabelHeight - 2*_yPadding,
                                                                   CGRectGetWidth(self.frame) - 2*_xPadding,
                                                                   textLabelHeight)];
        _textLabel.numberOfLines = 8;
        _textLabel.font = [UIFont mediumFontForSize:14];
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
        
        
        CGFloat titleLabelHeight = 40;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_xPadding,
                                                                    CGRectGetMinY(_textLabel.frame) - titleLabelHeight - _yPadding,
                                                                    CGRectGetWidth(self.frame) - 2*_xPadding,
                                                                    titleLabelHeight)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont titleFontForSize:20];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_titleLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_xPadding,
                                                                   CGRectGetMinY(_titleLabel.frame) + titleLabelHeight,
                                                                   CGRectGetWidth(self.frame) - 2*_xPadding,
                                                                   20)];
        _timeLabel.textColor = [UIColor mutedColor];
        _timeLabel.font = [UIFont mediumFontForSize:10];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    [self.timeLabel sizeToFit];
    
    CGRect frame;
    CGFloat ref = CGRectGetHeight(self.frame) - self.yPadding;
    if (self.textLabel.text) {
        self.textLabel.hidden = NO;
        frame = self.textLabel.frame;
        frame.origin.y = ref - CGRectGetHeight(frame) - self.yPadding;
        self.textLabel.frame = frame;
        ref = self.textLabel.frame.origin.y;
    } else {
        self.textLabel.hidden = YES;
    }
    
    frame = self.timeLabel.frame;
    frame.origin.y = ref - CGRectGetHeight(frame) - self.yPadding;
    self.timeLabel.frame = frame;
    ref = self.timeLabel.frame.origin.y;
    
    frame = self.titleLabel.frame;
    frame.origin.y = ref - CGRectGetHeight(frame) - self.yPadding;
    self.titleLabel.frame = frame;
}

// Crops an image to the size needed by this cell.
// Need to double dimensions for retina.
- (UIImage*)cropImage:(UIImage*)image
{
    CGSize dimensions = CGSizeMake(CGRectGetWidth(self.imageView.frame)*2,
                                   CGRectGetHeight(self.imageView.frame)*2);
    UIImage *croppedImage = [image scaleToCoverSize:dimensions];
    croppedImage = [croppedImage cropToSize:dimensions usingMode:NYXCropModeCenter];
    return croppedImage;
}

- (void)setImageForEntity:(BaseEntity*)entity
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    if (frameHeight == screenSize.height) {
        if (!entity.imageFull) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *croppedImage = [self cropImage:entity.image];
                entity.imageFull = croppedImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = entity.imageFull;
                });
            });
        } else {
            self.imageView.image = entity.imageFull;
        }
    } else if (frameHeight == kLargeCellHeight) {
        if (!entity.imageLarge) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *croppedImage = [self cropImage:entity.image];
                entity.imageLarge = croppedImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = entity.imageLarge;
                });
            });
        } else {
            self.imageView.image = entity.imageLarge;
        }
    } else {
        if (!entity.imageMid) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *croppedImage = [self cropImage:entity.image];
                entity.imageMid = croppedImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = entity.imageMid;
                });
            });
        } else {
            self.imageView.image = entity.imageMid;
        }
    }
}

@end
