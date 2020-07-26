//
//  ViewController.m
//  testasm
//
//  Created by Stephen Smith on 2019-12-21.
//  Copyright © 2019 Stephen Smith. All rights reserved.
//

#import "ViewController.h"

extern void start( void );

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    start();
}


@end
