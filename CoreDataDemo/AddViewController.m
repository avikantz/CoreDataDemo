//
//  AddViewController.m
//  CoreDataDemo
//
//  Created by Avikant Saini on 6/5/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.Show) {
		_nameField.text = [NSString stringWithFormat:@"%@", [_Show valueForKey:@"name"]];
		_seasonsField.text = [NSString stringWithFormat:@"%@", [_Show valueForKey:@"seasons"]];
		_episodesField.text = [NSString stringWithFormat:@"%@", [_Show valueForKey:@"episodes"]];
		_sizeField.text = [NSString stringWithFormat:@"%@", [_Show valueForKey:@"size"]];
	}
	
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: _doneButton, nil];
	self.navigationItem.title = @"Add Show";
	
	_nameField.delegate = self;
	[_nameField becomeFirstResponder];
	_seasonsField.delegate = self;
	_episodesField.delegate = self;
	_sizeField.delegate = self;
}

#pragma mark - Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.nameField) {
		[_nameField resignFirstResponder];
		[_seasonsField becomeFirstResponder];
	}
	else if (textField == self.seasonsField) {
		[_seasonsField resignFirstResponder];
		[_episodesField becomeFirstResponder];
	}
	else if (textField == self.episodesField) {
		[_episodesField resignFirstResponder];
		[_sizeField becomeFirstResponder];
	}
	else {
		[_sizeField resignFirstResponder];
		[self doneAction:self];
	}
	return YES;
}

#pragma mark - NSManagedObjectContext

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

#pragma mark - Other

- (IBAction)doneAction:(id)sender {
	NSManagedObjectContext *context = [self managedObjectContext];
	
	if (self.Show) {
		[self.Show setValue:_nameField.text forKey:@"name"];
		[self.Show setValue:_seasonsField.text forKey:@"seasons"];
		[self.Show setValue:_episodesField.text forKey:@"episodes"];
		[self.Show setValue:_sizeField.text forKey:@"size"];
	}
	else {
		NSManagedObject *newShow = [NSEntityDescription insertNewObjectForEntityForName:@"TVShow" inManagedObjectContext:context];
		[newShow setValue:_nameField.text forKey:@"name"];
		[newShow setValue:_seasonsField.text forKey:@"seasons"];
		[newShow setValue:_episodesField.text forKey:@"episodes"];
		[newShow setValue:_sizeField.text forKey:@"size"];
	}
		
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Can't Save : %@, %@", error, [error localizedDescription]);
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

@end
