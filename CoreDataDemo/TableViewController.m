//
//  TableViewController.m
//  CoreDataDemo
//
//  Created by Avikant Saini on 6/5/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "AddViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController {
	NSMutableArray *Shows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TVShow"];
	Shows = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
	
	Shows = [NSMutableArray arrayWithArray:[Shows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[obj1 valueForKey:@"name"] compare:[obj2 valueForKey:@"name"]];
	}]];
	
	[self.tableView reloadData];
	
//	self.navigationItem.leftBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [Shows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TableCellID" forIndexPath:indexPath];
    
	NSManagedObject *Show = [Shows objectAtIndex:indexPath.row];
	cell.nameLabel.text = [NSString stringWithFormat:@"%@", [Show valueForKey:@"name"]];
	cell.seasonsLabel.text = [NSString stringWithFormat:@"%@ Seasons", [Show valueForKey:@"seasons"]];
	cell.episodesLabel.text = [NSString stringWithFormat:@"%@ Episodes", [Show valueForKey:@"episodes"]];
	cell.sizeLabel.text = [NSString stringWithFormat:@"(%@)", [Show valueForKey:@"size"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSManagedObjectContext *context = [self managedObjectContext];
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[context deleteObject:[Shows objectAtIndex:indexPath.row]];
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Can't delete: %@, %@", error, [error localizedDescription]);
			return;
		}
		
		[Shows removeObjectAtIndex:indexPath.row];
		
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSManagedObjectContext *context = [self managedObjectContext];

	NSManagedObject *showToMove = [Shows objectAtIndex:fromIndexPath.row];
	
//	[context deleteObject:[Shows objectAtIndex:fromIndexPath.row]];
	[Shows removeObjectAtIndex:fromIndexPath.row];
	
	[Shows insertObject:showToMove atIndex:toIndexPath.row];
//	[context insertObject:showToMove];
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Can't Save: %@, %@", error, [error localizedDescription]);
		return;
	}
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowDetailSegue"]) {
		NSManagedObject *show = [Shows objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
		AddViewController *avc = [segue destinationViewController];
		avc.Show = show;
	}
}

@end
