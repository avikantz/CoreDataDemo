//
//  AddViewController.h
//  CoreDataDemo
//
//  Created by Avikant Saini on 6/5/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObject *Show;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *seasonsField;
@property (weak, nonatomic) IBOutlet UITextField *episodesField;
@property (weak, nonatomic) IBOutlet UITextField *sizeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneAction:(id)sender;

@end
