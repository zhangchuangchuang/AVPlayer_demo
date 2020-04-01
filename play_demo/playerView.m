//
//  playerView.m
//  play_demo
//
//  Created by 张闯闯 on 2020/4/1.
//  Copyright © 2020 张闯闯. All rights reserved.
//

#import "playerView.h"

@implementation playerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
