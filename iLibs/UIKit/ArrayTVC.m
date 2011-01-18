//
//  PrivacyVC.m
//
//  Created by Maarten Billemont on 05/11/10.
//  Copyright 2010 Lhunath. All rights reserved.
//

#import "ArrayTVC.h"
#import "ObjectUtils.h"

#define iLibsATVCCellID         @"ilibs.ArrayTVC.cell"
#define iLibsATVCRowName        @"ilibs.ArrayTVC.name"
#define iLibsATVCRowStyle       @"ilibs.ArrayTVC.style"
#define iLibsATVCRowToggled     @"ilibs.ArrayTVC.toggled"
#define iLibsATVCRowDelegate    @"ilibs.ArrayTVC.delegate"
#define iLibsATVCRowContext     @"ilibs.ArrayTVC.context"


@implementation ArrayTVC

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return self;
    
    _sections = [NSMutableArray new];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)removeAllRows {
    
    [_sections removeAllObjects];
}

- (void)removeRowWithName:(NSString *)aName fromSection:(NSString *)aSection {
    
    for (NSDictionary *section in _sections)
        if (!aSection || [[[section allKeys] lastObject] isEqualToString:aSection]) {
            NSMutableArray *sectionRows = [[section allValues] lastObject];
            
            for (NSDictionary *row in sectionRows)
                if ((aName == nil && [row objectForKey:iLibsATVCRowName] == [NSNull null]) ||
                    [[row objectForKey:iLibsATVCRowName] isEqualToString:aName]) {
                    [sectionRows removeObject:row];
                    return;
                }
        }
}

- (void)removeRowWithContext:(id)aContext fromSection:(NSString *)aSection {
    
    for (NSDictionary *section in _sections)
        if (!aSection || [[[section allKeys] lastObject] isEqualToString:aSection]) {
            NSMutableArray *sectionRows = [[section allValues] lastObject];
            
            for (NSDictionary *row in sectionRows)
                if (NSNullToNil([row objectForKey:iLibsATVCRowContext]) == aContext) {
                    [sectionRows removeObject:row];
                    return;
                }
        }
}

- (void)addRowWithName:(NSString *)aName style:(ArrayTVCRowStyle)aStyle toggled:(BOOL)isToggled toSection:(NSString *)aSection
          withDelegate:(id<ArrayTVCDelegate>)aDelegate context:(id)aContext {
    
    NSMutableArray *sectionRows = nil;
    for (NSDictionary *section in _sections)
        if ([[[section allKeys] lastObject] isEqualToString:aSection]) {
            sectionRows = [[section allValues] lastObject];
            break;
        }
    if (!sectionRows)
        [_sections addObject:[NSDictionary dictionaryWithObject:sectionRows = [NSMutableArray array] forKey:aSection]];
    
    [sectionRows addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                            NilToNSNull(aName),                         iLibsATVCRowName,
                            [NSNumber numberWithUnsignedInt:aStyle],    iLibsATVCRowStyle,
                            [NSNumber numberWithBool:isToggled],        iLibsATVCRowToggled,
                            NilToNSNull(aDelegate),                     iLibsATVCRowDelegate,
                            NilToNSNull(aContext),                      iLibsATVCRowContext,
                            nil]];
}

- (void)customizeCell:(UITableViewCell *)cell forRow:(NSDictionary *)row withContext:(id)context {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    return [[[[_sections objectAtIndex:section] allValues] lastObject] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[[_sections objectAtIndex:section] allKeys] lastObject];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iLibsATVCCellID];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iLibsATVCCellID] autorelease];
    
    NSArray *sectionRows = [[[_sections objectAtIndex:indexPath.section] allValues] lastObject];
    NSDictionary *row = [sectionRows objectAtIndex:indexPath.row];
    
    cell.textLabel.text = NSNullToNil([row objectForKey:iLibsATVCRowName]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    switch ([NSNullToNil([row objectForKey:iLibsATVCRowStyle]) unsignedIntValue]) {
        case ArrayTVCRowStylePlain:
            break;
        case ArrayTVCRowStyleLink: {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        }
        case ArrayTVCRowStyleDisclosure: {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case ArrayTVCRowStyleCheck: {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if ([[row objectForKey:iLibsATVCRowToggled] boolValue])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
        case ArrayTVCRowStyleToggle: {
            UISwitch *switchView = [[[UISwitch alloc] init] autorelease];
            switchView.on = [[row objectForKey:iLibsATVCRowToggled] boolValue];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = switchView;
            break;
        }
    }
    
    [self customizeCell:cell forRow:row withContext:NSNullToNil([row objectForKey:iLibsATVCRowContext])];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionName = [[[_sections objectAtIndex:indexPath.section] allKeys] lastObject];
    NSArray *sectionRows = [[[_sections objectAtIndex:indexPath.section] allValues] lastObject];
    NSMutableDictionary *row = [sectionRows objectAtIndex:indexPath.row];
    
    BOOL newToggled = ![[row objectForKey:iLibsATVCRowToggled] boolValue];
    if ([NSNullToNil([row objectForKey:iLibsATVCRowDelegate]) shouldActivateRowNamed:NSNullToNil([row objectForKey:iLibsATVCRowName])
                                                                           inSection:sectionName
                                                                         withContext:NSNullToNil([row objectForKey:iLibsATVCRowContext])
                                                                            toggleTo:newToggled]) {
        [row setObject:[NSNumber numberWithBool:newToggled] forKey:iLibsATVCRowToggled];
        switch ([NSNullToNil([row objectForKey:iLibsATVCRowStyle]) unsignedIntValue]) {
            case ArrayTVCRowStyleToggle: {
                [(UISwitch *)[[self.tableView cellForRowAtIndexPath:indexPath] accessoryView] setOn:newToggled animated:YES];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
            }
            case ArrayTVCRowStyleCheck: {
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
            default:
                break;
        }
    }
}

@end
