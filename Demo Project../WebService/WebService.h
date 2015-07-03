//
//  WebService.h
//  Plan it Sync it
//
//  Created by Vivek on 21/04/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+(WebService *)sharedWebService;


- (void) callUpdateUserImageWebService:(NSDictionary *)dictionary;
- (void) callUpdatePreferencesWebService:(NSDictionary *)dictionary;
- (void) callgetPrefWebService:(NSDictionary *)dictionary;
- (void) callClearNotificationWebService:(NSDictionary *)dictionary;
- (void) callGetAllContactsListWebService:(NSDictionary *)dictionary;
- (void) callDeleteContactWebService:(NSDictionary *)dictionary;
- (void) callUpdateContactWebService:(NSDictionary *)dictionary;
- (void) callInsertNewContactWebService:(NSDictionary *)dictionary;
- (void) callGetCalendarAllEventsListingWebService:(NSDictionary *)dictionary;
- (void) callGetTimelineWebService:(NSDictionary *)dictionary;
- (void) callGetListOfNotificationWebService:(NSDictionary *)dictionary;
- (void) cllDeleteIndividualNotificationWebService:(NSDictionary *)dictionary;
- (void) callClearAllNotificationWebService:(NSDictionary *)dictionary;
- (void) callClearIndividualNotificationWebService:(NSDictionary *)dictionary;
- (void) callAddEventWebService:(NSDictionary *)dictionary;
- (void) callGetListOfEventsWebService:(NSDictionary *)dictionary;
- (void) callEditEventWebService:(NSDictionary *)dictionary;
- (void) callDeleteEventsWebService:(NSDictionary *)dictionary;
- (void) callForgotPasswordWebService:(NSDictionary *)dictionary;
- (void) callVerifyMobileNumberWebService:(NSDictionary *)dictionary;
- (void) callSavePasswordWebService:(NSDictionary *)dictionary;
- (void) callChangePasswordWebService:(NSDictionary *)dictionary;
- (void) callRegisterNewUser:(NSDictionary *)dictionary;
- (void) callLoginWebService:(NSDictionary *)dictionary;
- (void) callEditProfileWebService:(NSDictionary *)dictionary;
- (void) callGetListOfInboxMessagesWebService:(NSDictionary *)dictionary;
- (void) callGetListOfSentMessagesWebService:(NSDictionary *)dictionary;
- (void) callGetListOfTrashMessagesWebService:(NSDictionary *)dictionary;
- (void) callGetUserProfileDataWebService:(NSDictionary *)dictionary;
- (void) callGetMyAvalabilityWebService:(NSDictionary *)dictionary;
- (void) callSetMyAvalabilityWebService:(NSDictionary *)dictionary;
-(void) callgetLocation:(NSDictionary *)dictionary;
- (void) callUserProfileForMasterTable:(NSDictionary *)dictionary;
- (void) callGetListOfSchoolList:(NSDictionary *)dictionary;
-(void) callGetSingleEventsWebService:(NSDictionary *)dictionary;
-(void) callGetEditSingleEventsWebService:(NSDictionary *)dictionary;
- (void) callgetdetailForMasterTable:(NSDictionary *)dictionary;
- (void) callDeleteEventsFromEventViewControllerWebService:(NSDictionary *)dictionary;
- (void) callGetListMyAvalabilityWebService:(NSDictionary *)dictionary;
- (void) callGetListOfRosterWebService:(NSDictionary *)dictionary;
- (void) callSetRequestCancelWebService:(NSDictionary *)dictionary;
- (void) callGetListOfCategoryWebService:(NSDictionary *)dictionary;
- (void) callgetListOfLocation:(NSDictionary *)dictionary;
- (void) callgetListOfTimeline:(NSDictionary *)dictionary;




- (void) callGetLeaugePointSettingWebService:(NSDictionary *)dictionary;
- (void) callAddFinanceDetailWebService:(NSDictionary *)dictionary;
- (void) callEditFinanceDetailWebService:(NSDictionary *)dictionary;
- (void) callDeleteFinanceDetailWebService:(NSDictionary *)dictionary;
- (void) callSelectFinanceDetailWebService:(NSDictionary *)dictionary;
- (void) callAddTransactionDetailWebService:(NSDictionary *)dictionary;
- (void) callEditTransactionDetailWebService:(NSDictionary *)dictionary;
- (void) callDeleteTransactionDetailWebService:(NSDictionary *)dictionary;
- (void) callSelectTransactionDetailWebService:(NSDictionary *)dictionary;
- (void) callGetPlayerProfileWebService:(NSDictionary *)dictionary;
- (void) callFetchUpcomingMatchWebService:(NSDictionary *)dictionary;
- (void) callSavePlayerForUpcomingMatchWebService:(NSDictionary *)dictionary;
- (void) callGetFinishedMatchListWebService:(NSDictionary *)dictionary;
- (void) callSaveMatchPointWebService:(NSDictionary *)dictionary;
- (void) callSelectMatchPointWebService:(NSDictionary *)dictionary;
- (void) callSavePlayerPointWebService:(NSDictionary *)dictionary;
- (void) callPlayerStandingListWebService:(NSDictionary *)dictionary;
- (void) callLeaugeWiseTeamListWebService:(NSDictionary *)dictionary;
- (void) callTeamWiseUpcomingMatchWebService:(NSDictionary *)dictionary;
- (void) callCommentsOnMatchByPlayerWebService:(NSDictionary *)dictionary;
- (void) callDeleteCommentsWebService:(NSDictionary *)dictionary;
- (void) callSelectCommentWebService:(NSDictionary *)dictionary;
- (void) callVoteForPlayerWebService:(NSDictionary *)dictionary;
- (void) callDeleteVoteWebService:(NSDictionary *)dictionary;
- (void) callGetSelectedteamForSelectedMatchWebService:(NSDictionary *)dictionary;
- (void) callSelectPlayerListWebService:(NSDictionary *)dictionary;
- (void) callTeamStaningWebService:(NSDictionary *)dictionary;
- (void) callPreviousMatchResultWebService:(NSDictionary *)dictionary;
- (void) callEditPlayerProfileWebService:(NSDictionary *)dictionary;
- (void) callSelectPlayerPointWebService:(NSDictionary *)dictionary;


@end
