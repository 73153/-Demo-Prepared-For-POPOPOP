//
//  WebService.m
//  Plan it Sync it
//
//  Created by Vivek on 21/04/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "WebService.h"
#import "ASIFormDataRequest.h"
#import "AppConstant.h"
#import "MBProgressHUD.h"

static WebService *webService;
@implementation WebService


+(WebService *)sharedWebService{
    if(!webService){
        webService = [[WebService alloc] init];
    }
    return webService;
}

- (void) loginResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary) {
        NSDictionary *dict;
        NSDictionary *otherDict;
        NSDictionary *responseDataDict;
        if([[dictionary objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
        {
            otherDict = [dictionary objectForKey:@"data"];
            if([[otherDict objectForKey:@"preference"] isKindOfClass:[NSDictionary class]])
            {
                responseDataDict = [otherDict objectForKey:@"preference"];
            }
        }
        if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSString *userId = [NSString stringWithFormat:@"%@",[responseDataDict objectForKey:@"userid"]];
        
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            [[NSUserDefaults standardUserDefaults] setValue:userId forKey:kUserId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:dictionary];
    }
    
}

- (void) callLoginWebService:(NSDictionary *)dictionary{
    // Add device Toke Here
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=login", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    NSString *url = [NSString stringWithFormat:@"https://www.planitsyncit.com/app/android/webservices.php?action=login&email=%@&password=%@",[dictionary objectForKey:kUserName],[dictionary objectForKey:kPassword]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:kUserName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"email"];
    [request addPostValue:[[dictionary objectForKey:kPassword] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
    
    [request setDidFinishSelector:@selector(loginResponse:)];
    [request startAsynchronous];
}


- (void) registerNewUserResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary) {
        
        NSDictionary *dict;
        NSDictionary *otherDict;
        NSDictionary *responseDataDict;
        if([[dictionary objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
        {
            otherDict = [dictionary objectForKey:@"data"];
            if([[otherDict objectForKey:@"userid"] isKindOfClass:[NSString class]])
            {
                
            }
        }
        if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        NSString *userId = [NSString stringWithFormat:@"%@",[otherDict objectForKey:@"userid"]];
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        NSLog(@"message = %@",[NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]]);
        NSLog(@"message = %@",[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"data"]]);
        
        
        if([[otherDict objectForKey:@"preference"] isKindOfClass:[NSDictionary class]]){
            responseDataDict = [otherDict objectForKey:@"preference"];
        }
        [[NSUserDefaults standardUserDefaults] setValue:userId forKey:kUserId];
        
        if([str isEqualToString:@"success"]){
            [[NSUserDefaults standardUserDefaults] setValue:userId forKey:kUserId];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:kForgotPassSuccessVerifyKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRegisrationSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kRegisrationFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRegisrationFailed object:dictionary];
    }
}


- (void) callRegisterNewUser:(NSDictionary *)dictionary{
    // Add device Toke Here
    //     http://www.planitsyncit.com/app/android/webservices.php?action=register&email=keyur@keyur.com&name=keyur&gender=M&country_code=44&country=GB&mobile=1234567891
    
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=register",kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"email"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"email"];
    [request addPostValue:[[dictionary objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"name"];
    [request addPostValue:[[dictionary objectForKey:@"gender"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"gender"];
    [request addPostValue:[[dictionary objectForKey:@"country_code"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"country_code"];
    [request addPostValue:[[dictionary objectForKey:@"password"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
    [request addPostValue:[[dictionary objectForKey:@"mobile"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"mobile"];
    [request addPostValue:[[dictionary objectForKey:@"country"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"country"];
    
    [request setRequestMethod:@"POST"];
    [request setDidFinishSelector:@selector(registerNewUserResponse:)];
    
    [request startAsynchronous];
    
}

- (void) verifyMobileNumberResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary) {
        NSDictionary *dict;
        NSDictionary *otherDict;
        NSDictionary *responseDataDict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            otherDict = [dictionary objectForKey:@"data"];
            if([[otherDict objectForKey:@"preference"] isKindOfClass:[NSDictionary class]])
            {
                responseDataDict = [otherDict objectForKey:@"preference"];
            }
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        NSLog(@"message = %@",[NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]]);
        NSLog(@"message = %@",[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"data"]]);
        
        if([str isEqualToString:@"success"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:kContactVerifyKeySuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kContactVerifyKeyFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kContactVerifyKeyFailed object:dictionary];
    }
}


- (void) callVerifyMobileNumberWebService:(NSDictionary *)dictionary
{
    //    http://dev.planitsyncit.com/app/android/webservices.php?action=resetpass&password=123&mobile=123456789
    
    // Add device Toke Here
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=verify",kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"verify_key"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"verify_key"];
    [request addPostValue:[[dictionary objectForKey:@"mobile"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"mobile"];
    
    [request setDidFinishSelector:@selector(verifyMobileNumberResponse:)];
    [request startAsynchronous];
}

- (void) forgotPassResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary) {
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:kForgotPassSuccessVerifyKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:kForgotPassSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kForgotPassFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kForgotPassFailed object:dictionary];
    }
}

- (void) callForgotPasswordWebService:(NSDictionary *)dictionary{
    // Add device Toke Here
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=forgetpass",kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"mobile"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"mobile"];
    [request setDidFinishSelector:@selector(forgotPassResponse:)];
    [request startAsynchronous];
}


- (void) savePasswordWebServiceResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary) {
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPasswordMatchSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kPasswordMatchFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPasswordMatchFailed object:dictionary];
    }
}


- (void) callSavePasswordWebService:(NSDictionary *)dictionary{
    // Add device Toke Here
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=resetpass",kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:[[dictionary objectForKey:@"password"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
    [request addPostValue:[[dictionary objectForKey:@"mobile"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"mobile"];
    
    [request setDidFinishSelector:@selector(savePasswordWebServiceResponse:)];
    [request startAsynchronous];
    
}

- (void) changePasswordWebServiceResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary) {
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kChangePasswordSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kChangePasswordFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangePasswordFailed object:dictionary];
    }
}



- (void) callChangePasswordWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=changepass",kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"oldpassword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"oldpassword"];
    [request addPostValue:[[dictionary objectForKey:@"newpassword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"newpassword"];
    
    [request setDidFinishSelector:@selector(changePasswordWebServiceResponse:)];
    [request startAsynchronous];
}


//http://dev.planitsyncit.com/app/android/webservices.php?action=verify&verify_key=123mobile=98675675

- (void) updateUserImageResponse:(ASIFormDataRequest *)request{
    NSLog(@"%@",request);
    //
    //    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    //    if(dictionary){
    //        NSDictionary *dict;
    //        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
    //        {
    //            NSLog(@"NSArray");
    //        }
    //        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
    //            dict = [dictionary objectForKey:@"meta"];
    //        }
    //
    //        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
    //        NSLog(@"Responce =  %@",str);
    //        if([str isEqualToString:@"success"]){
    //
    //            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserImageSuccess object:dictionary];
    //        }
    //        else{
    //            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserImageFailed object:dictionary];
    //        }
    //    }
    //    else
    //    {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserImageFailed object:dictionary];
    //    }
}

- (void) callUpdateUserImageWebService:(NSDictionary *)dictionary{
    //    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=updateimage", kPlanitSyncitURL];
    //    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    //    [request setDelegate:self];
    //    [request addPostValue:[[dictionary objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"image"];
    //    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    //    [request setRequestMethod:@"POST"];
    //
    //    [request setDidFinishSelector:@selector(updateUserImageResponse:)];
    //    [request startAsynchronous];
}

- (void) updatePreferencesResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePreferencesSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePreferencesFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePreferencesFailed object:dictionary];
    }
}

- (void) callUpdatePreferencesWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=updatepref", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"default_guest_limit"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_guest_limit"];
    [request addPostValue:[[dictionary objectForKey:@"timeline_repeating_limit"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"timeline_repeating_limit"];
    [request addPostValue:[[dictionary objectForKey:@"default_time_format"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_time_format"];
    [request addPostValue:[[dictionary objectForKey:@"default_time_zone"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_time_zone"];
    [request addPostValue:[[dictionary objectForKey:@"default_date_format"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_date_format"];
    [request addPostValue:[[dictionary objectForKey:@"default_color_event"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_color_event"];
    [request addPostValue:[[dictionary objectForKey:@"default_location"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_location"];
    [request addPostValue:[[dictionary objectForKey:@"default_access"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_access"];
    [request addPostValue:[[dictionary objectForKey:@"default_dob"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_dob"];
    [request addPostValue:[[dictionary objectForKey:@"default_rsvp_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_rsvp_date"];
    [request addPostValue:[[dictionary objectForKey:@"default_del_notification"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_del_notification"];
    [request addPostValue:[[dictionary objectForKey:@"default_calendar"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"default_calendar"];
    [request addPostValue:[[dictionary objectForKey:@"timeline_future_year_limit"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"timeline_future_year_limit"];
    [request addPostValue:[[dictionary objectForKey:@"account_access_admin"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"account_access_admin"];
    [request addPostValue:[[dictionary objectForKey:@"location_other"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"location_other"];
    
    
    [request setRequestMethod:@"POST"];
    [request setDidFinishSelector:@selector(updatePreferencesResponse:)];
    [request startAsynchronous];
}


- (void) getPrefResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        NSDictionary *otherDict;
        NSDictionary *responseDataDict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]])
        {
            otherDict = [dictionary objectForKey:@"data"];
        }
        if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetPrefSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetPrefFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetPrefFailed object:dictionary];
    }
}

- (void) callgetPrefWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=getpref", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request setDidFinishSelector:@selector(getPrefResponse:)];
    [request startAsynchronous];
}



- (void) getdetailForMasterTableResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileForMasterTableSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileForMasterTableFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileForMasterTableFailed object:dictionary];
    }
}

- (void) callgetdetailForMasterTable:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=profile", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request setDidFinishSelector:@selector(getdetailForMasterTableResponse:)];
    [request startAsynchronous];
}


- (void) getLocationSuccess:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetLocationSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetLocationFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetPrefFailed object:dictionary];
    }
}

- (void) callgetLocation:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=getlocation", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request setDidFinishSelector:@selector(getLocationSuccess:)];
    [request startAsynchronous];
}


- (void) getListOfLocationSuccess:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfLocationSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfLocationFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfLocationFailed object:dictionary];
    }
}

- (void) callgetListOfLocation:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=getlocation", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request setDidFinishSelector:@selector(getListOfLocationSuccess:)];
    [request startAsynchronous];
}


- (void) clearNotificationResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kClearIndividualNotificationSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kClearIndividualNotificationFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kClearIndividualNotificationFailed object:dictionary];
    }
}

- (void) callClearNotificationWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservice_notification.php?action=clearnotification", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"id"];
    [request setDidFinishSelector:@selector(clearNotificationResponse:)];
    [request startAsynchronous];
}

- (void) getAllContactsListResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetAllContactsListSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetAllContactsListFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetAllContactsListFailed object:dictionary];
    }
}

- (void) callGetAllContactsListWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservice_contact.php?action=getlist", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"search"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"search"];
    [request addPostValue:[[dictionary objectForKey:@"limit_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_start"];
    [request addPostValue:[[dictionary objectForKey:@"limit_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_end"];
    
    [request setDidFinishSelector:@selector(getAllContactsListResponse:)];
    [request startAsynchronous];
}

- (void) deleteContactResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);        NSLog(@"Responce =  %@",str);
        
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteContactSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteContactFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteContactFailed object:dictionary];
    }
}

- (void) callDeleteContactWebService:(NSDictionary *)deleteDict{
    NSMutableArray *dictArray = [[NSMutableArray alloc] initWithObjects: deleteDict,nil];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    //    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSLog(@"Dict:%@", jsonString);
    
    NSString *url = [NSString stringWithFormat:@"%@/webservice_contact.php?action=deletecontact", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"DELETE"];
    
    [request addPostValue:jsonString forKey:@"data"];
    
    [request setDidFinishSelector:@selector(deleteContactResponse:)];
    [request startAsynchronous];
}

- (void) updateContactResponse:(ASIFormDataRequest *)request{
    //    NSString *response = [[request responseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateContactSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateContactFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateContactFailed object:dictionary];
    }
}

- (void) callUpdateContactWebService:(NSDictionary *)dictionary{
    
    NSMutableArray *dictArray = [[NSMutableArray alloc] initWithObjects: dictionary,nil];
    
    NSData* nsdata = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* jsonString = [[NSString alloc] initWithData:nsdata encoding:NSUTF8StringEncoding];
    
    //    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSLog(@"Dict:%@", jsonString);
    NSString *url = [NSString stringWithFormat:@"%@/webservice_contact.php?action=update_contact", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:jsonString forKey:@"data"];
    
    [request setDidFinishSelector:@selector(updateContactResponse:)];
    [request startAsynchronous];
}

- (void) insertNewContactResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kInsertNewContactSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kInsertNewContactFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kInsertNewContactFailed object:dictionary];
    }
}

- (void) callInsertNewContactWebService:(NSDictionary *)dictionary{
    
    NSMutableArray *dictArray = [[NSMutableArray alloc] initWithObjects: dictionary,nil];
    
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/webservice_contact.php?action=insert_contact", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setPostValue:jsonString forKey:@"data"];
    
    [request setRequestMethod:@"POST"];
    
    [request setDidFinishSelector:@selector(insertNewContactResponse:)];
    [request startAsynchronous];
}

- (void) getCalendarAllEventsListingResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetCalendarAllEventsListingSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetCalendarAllEventsListingFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetCalendarAllEventsListingFailed object:dictionary];
    }
}

- (void) callGetCalendarAllEventsListingWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices_calendar.php?action=getcal_by_date", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"year"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"year"];
    [request addPostValue:[[dictionary objectForKey:@"user_id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"user_id"];
    
    [request setRequestMethod:@"POST"];
    
    [request setDidFinishSelector:@selector(getCalendarAllEventsListingResponse:)];
    [request startAsynchronous];
}

- (void) getListOfNotificationResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfNotificationSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfNotificationFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfNotificationFailed object:dictionary];
    }
}

- (void) callGetListOfNotificationWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservice_notification.php?action=list_notification", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request setDidFinishSelector:@selector(getListOfNotificationResponse:)];
    [request startAsynchronous];
}

- (void) getListOfSchoolListResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfSchoolListSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfSchoolListFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfNotificationFailed object:dictionary];
    }
}

- (void) callGetListOfSchoolList:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices_school.php?action=getinterview", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    
    [request setDidFinishSelector:@selector(getListOfSchoolListResponse:)];
    [request startAsynchronous];
}


- (void) getListOfInboxMessagesWebService:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfInboxMessagesSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfInboxMessagesFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfInboxMessagesFailed object:dictionary];
    }
}

- (void) callGetListOfInboxMessagesWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservice_message.php?action=inboxitem&userid=%@&search=%@&limit_start=%@&limit_end=%@", kPlanitSyncitURL,[dictionary objectForKey:kUserId],[dictionary objectForKey:@"search"],[dictionary objectForKey:@"limit_start"],[dictionary objectForKey:@"limit_end"]];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request setDidFinishSelector:@selector(getListOfInboxMessagesWebService:)];
    [request startAsynchronous];
}

- (void) getListOfSentMessagesWebService:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfSentMessagesSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfSentMessagesFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfSentMessagesFailed object:dictionary];
    }
}

- (void) callGetListOfSentMessagesWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservice_message.php?action=sentitem&userid=%@&search=%@&limit_start=%@&limit_end=%@", kPlanitSyncitURL,[dictionary objectForKey:kUserId],[dictionary objectForKey:@"search"],[dictionary objectForKey:@"limit_start"],[dictionary objectForKey:@"limit_end"]];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request setDidFinishSelector:@selector(getListOfSentMessagesWebService:)];
    [request startAsynchronous];
}

- (void) getListOfTrashMessagesWebService:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfTrashMessagesSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfTrashMessagesFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfTrashMessagesFailed object:dictionary];
    }
}

- (void) callGetListOfTrashMessagesWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservice_message.php?action=trashitem&userid=%@&search=%@&limit_start=%@&limit_end=%@", kPlanitSyncitURL,[dictionary objectForKey:kUserId],[dictionary objectForKey:@"search"],[dictionary objectForKey:@"limit_start"],[dictionary objectForKey:@"limit_end"]];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request setDidFinishSelector:@selector(getListOfTrashMessagesWebService:)];
    [request startAsynchronous];
}



- (void) clearAllNotificationResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kClearAllNotificationSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kClearAllNotificationFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kClearAllNotificationFailed object:dictionary];
    }
}

- (void) callClearAllNotificationWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservice_notification.php?action=clearnotification", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"id"];
    
    [request setDidFinishSelector:@selector(clearAllNotificationResponse:)];
    [request startAsynchronous];
}

- (void) clearIndividualNotificationResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kClearIndividualNotificationSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kClearIndividualNotificationFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kClearIndividualNotificationFailed object:dictionary];
    }
}

- (void) callClearIndividualNotificationWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservice_notification.php?action=deletesinglenotification",kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"notification_id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"notification_id"];
    [request setDidFinishSelector:@selector(clearIndividualNotificationResponse:)];
    [request startAsynchronous];
}

- (void) addEventResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddEventSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddEventFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddEventFailed object:dictionary];
    }
}

- (void) callAddEventWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=add",kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"action"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"action"];
    [request addPostValue:[[dictionary objectForKey:@"notification"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"notification"];
    
    [request addPostValue:[[dictionary objectForKey:@"start_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"start_date"];
    [request addPostValue:[[dictionary objectForKey:@"end_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"end_date"];
    [request addPostValue:[[dictionary objectForKey:@"last_rsvp_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"last_rsvp_date"];
    [request addPostValue:[[dictionary objectForKey:@"reminder_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder_date"];
    [request addPostValue:[[dictionary objectForKey:@"r_end_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"r_end_date"];
    [request addPostValue:[[dictionary objectForKey:@"start_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"start_time"];
    [request addPostValue:[[dictionary objectForKey:@"end_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"end_time"];
    [request addPostValue:[[dictionary objectForKey:@"estimate_time_minute"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"estimate_time_minute"];
    [request addPostValue:[[dictionary objectForKey:@"estimate_time_hours"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"estimate_time_hours"];
    [request addPostValue:[[dictionary objectForKey:@"weekday"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"weekday"];
    [request addPostValue:[[dictionary objectForKey:@"conflict_confirm"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"conflict_confirm"];
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"save_type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"save_type"];
    [request addPostValue:[[dictionary objectForKey:@"event_type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"event_type"];
    [request addPostValue:[[dictionary objectForKey:@"reminder"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder"];
    [request addPostValue:[[dictionary objectForKey:@"repead_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"repead_end"];
    [request addPostValue:[[dictionary objectForKey:@"reminder_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder_time"];
    [request addPostValue:[[dictionary objectForKey:@"reminder_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder_date"];
    [request addPostValue:[[dictionary objectForKey:@"rsvp_disable"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"rsvp_disable"];
    [request addPostValue:[[dictionary objectForKey:@"location"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"location"];
    [request addPostValue:[[dictionary objectForKey:@"full_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"full_time"];
    [request addPostValue:[[dictionary objectForKey:@"title"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"title"];
    [request addPostValue:[[dictionary objectForKey:@"description"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"description"];
    [request addPostValue:[[dictionary objectForKey:@"access"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"access"];
    [request addPostValue:[[dictionary objectForKey:@"color_code"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"color_code"];
    [request addPostValue:[[dictionary objectForKey:@"category"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"category"];
    [request addPostValue:[[dictionary objectForKey:@"category_other"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"category_other"];
    [request addPostValue:[[dictionary objectForKey:@"offset_before"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"offset_before"];
    [request addPostValue:[[dictionary objectForKey:@"ce_primary_id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_primary_id"];
    [request addPostValue:[[dictionary objectForKey:@"ce_days"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_days"];
    [request addPostValue:[[dictionary objectForKey:@"ce_hours"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_hours"];
    [request addPostValue:[[dictionary objectForKey:@"ce_minutes"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_minutes"];
    [request addPostValue:[[dictionary objectForKey:@"repeat_type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"repeat_type"];
    [request addPostValue:[[dictionary objectForKey:@"repeat_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"repeat_end"];
    [request addPostValue:[[dictionary objectForKey:@"no_of_times"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"no_of_times"];
    [request addPostValue:[[dictionary objectForKey:@"instance_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"instance_date"];
    [request addPostValue:[[dictionary objectForKey:@"location_other"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"location_other"];
    NSString *imageStringAfterCrop = [dictionary objectForKey:@"image_path"];
    if(!([imageStringAfterCrop isEqualToString:@""]) && imageStringAfterCrop != nil)
    {
        [request addPostValue:[[dictionary objectForKey:@"image_path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"image_path"];
    }
    [request setRequestMethod:@"POST"];
    
    [request setDidFinishSelector:@selector(addEventResponse:)];
    [request startAsynchronous];
}



- (void) getListOfTimelineResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfTimelineSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfTimelineFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfTimelineFailed object:dictionary];
    }
}


- (void) callgetListOfTimeline:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_calendar.php?action=get_timeline", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"user_id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"user_id"];
    
    [request setRequestMethod:@"GET"];
    [request setDidFinishSelector:@selector(getListOfTimelineResponse:)];
    [request startAsynchronous];
}


- (void) getListOfEventsResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfEventsSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfEventsFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfEventsFailed object:dictionary];
    }
}


- (void) callGetListOfEventsWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=lists", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"eventid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"eventid"];
    [request addPostValue:[[dictionary objectForKey:@"instance_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"instance_date"];
    [request addPostValue:[[dictionary objectForKey:@"search"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"search"];
    [request addPostValue:[[dictionary objectForKey:@"upcoming"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"upcoming"];
    [request addPostValue:[[dictionary objectForKey:@"past"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"past"];
    [request addPostValue:[[dictionary objectForKey:@"limit_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_start"];
    [request addPostValue:[[dictionary objectForKey:@"limit_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_end"];
    [request addPostValue:[[dictionary objectForKey:@"reverse"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reverse"];
    
    [request setRequestMethod:@"GET"];
    [request setDidFinishSelector:@selector(getListOfEventsResponse:)];
    [request startAsynchronous];
}



- (void) getListOfCategoryResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfCategorySuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfCategoryFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfCategoryFailed object:dictionary];
    }
}


- (void) callGetListOfCategoryWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=categories", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request setRequestMethod:@"GET"];
    [request setDidFinishSelector:@selector(getListOfCategoryResponse:)];
    [request startAsynchronous];
}

- (void) getSingleEventsWebServiceResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetSingleEventsWebServiceSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetSingleEventsWebServiceFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetSingleEventsWebServiceFailed object:dictionary];
    }
}


- (void) callGetSingleEventsWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=lists", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"eventid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"eventid"];
    [request addPostValue:[[dictionary objectForKey:@"instance_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"instance_date"];
    [request addPostValue:[[dictionary objectForKey:@"search"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"search"];
    [request addPostValue:[[dictionary objectForKey:@"upcoming"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"upcoming"];
    [request addPostValue:[[dictionary objectForKey:@"past"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"past"];
    [request addPostValue:[[dictionary objectForKey:@"limit_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_start"];
    [request addPostValue:[[dictionary objectForKey:@"limit_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_end"];
    [request addPostValue:[[dictionary objectForKey:@"reverse"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reverse"];
    
    [request setRequestMethod:@"POST"];
    [request setDidFinishSelector:@selector(getSingleEventsWebServiceResponse:)];
    [request startAsynchronous];
}

- (void) getEditSingleEventsWebService:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetEditSingleEventsWebServiceSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetEditSingleEventsWebServiceFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetEditSingleEventsWebServiceFailed object:dictionary];
    }
}
-(void) callGetEditSingleEventsWebService:(NSDictionary *)dictionary
{
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=lists", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"eventid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"eventid"];
    [request addPostValue:[[dictionary objectForKey:@"instance_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"instance_date"];
    [request addPostValue:[[dictionary objectForKey:@"search"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"search"];
    [request addPostValue:[[dictionary objectForKey:@"upcoming"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"upcoming"];
    [request addPostValue:[[dictionary objectForKey:@"past"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"past"];
    [request addPostValue:[[dictionary objectForKey:@"limit_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_start"];
    [request addPostValue:[[dictionary objectForKey:@"limit_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"limit_end"];
    [request addPostValue:[[dictionary objectForKey:@"reverse"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reverse"];
    
    [request setRequestMethod:@"POST"];
    [request setDidFinishSelector:@selector(getEditSingleEventsWebService:)];
    [request startAsynchronous];
}

- (void) editEventResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditEventSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditEventFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEditEventFailed object:dictionary];
    }
}

- (void) callEditEventWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=edit",kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:@"action"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"action"];
    
    [request addPostValue:[[dictionary objectForKey:@"id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"id"];
    [request addPostValue:[[dictionary objectForKey:@"notification"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"notification"];
    [request addPostValue:[[dictionary objectForKey:@"reminder"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder"];
    [request addPostValue:[[dictionary objectForKey:@"start_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"start_date"];
    [request addPostValue:[[dictionary objectForKey:@"end_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"end_date"];
    [request addPostValue:[[dictionary objectForKey:@"last_rsvp_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"last_rsvp_date"];
    [request addPostValue:[[dictionary objectForKey:@"reminder_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder_date"];
    [request addPostValue:[[dictionary objectForKey:@"r_end_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"r_end_date"];
    [request addPostValue:[[dictionary objectForKey:@"start_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"start_time"];
    [request addPostValue:[[dictionary objectForKey:@"end_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"end_time"];
    [request addPostValue:[[dictionary objectForKey:@"estimate_time_minute"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"estimate_time_minute"];
    [request addPostValue:[[dictionary objectForKey:@"estimate_time_hours"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"estimate_time_hours"];
    [request addPostValue:[[dictionary objectForKey:@"weekday"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"weekday"];
    [request addPostValue:[[dictionary objectForKey:@"conflict_confirm"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"conflict_confirm"];
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"save_type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"save_type"];
    [request addPostValue:[[dictionary objectForKey:@"event_type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"event_type"];
    
    [request addPostValue:[[dictionary objectForKey:@"repead_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"repead_end"];
    [request addPostValue:[[dictionary objectForKey:@"reminder_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder_time"];
    [request addPostValue:[[dictionary objectForKey:@"reminder_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reminder_date"];
    [request addPostValue:[[dictionary objectForKey:@"rsvp_disable"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"rsvp_disable"];
    [request addPostValue:[[dictionary objectForKey:@"location"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"location"];
    [request addPostValue:[[dictionary objectForKey:@"full_time"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"full_time"];
    [request addPostValue:[[dictionary objectForKey:@"title"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"title"];
    [request addPostValue:[[dictionary objectForKey:@"description"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"description"];
    [request addPostValue:[[dictionary objectForKey:@"access"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"access"];
    [request addPostValue:[[dictionary objectForKey:@"color_code"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"color_code"];
    [request addPostValue:[[dictionary objectForKey:@"category"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"category"];
    [request addPostValue:[[dictionary objectForKey:@"category_other"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"category_other"];
    [request addPostValue:[[dictionary objectForKey:@"offset_before"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"offset_before"];
    [request addPostValue:[[dictionary objectForKey:@"ce_primary_id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_primary_id"];
    [request addPostValue:[[dictionary objectForKey:@"ce_days"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_days"];
    [request addPostValue:[[dictionary objectForKey:@"ce_hours"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_hours"];
    [request addPostValue:[[dictionary objectForKey:@"ce_minutes"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ce_minutes"];
    [request addPostValue:[[dictionary objectForKey:@"repeat_type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"repeat_type"];
    [request addPostValue:[[dictionary objectForKey:@"repeat_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"repeat_end"];
    [request addPostValue:[[dictionary objectForKey:@"no_of_times"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"no_of_times"];
    [request addPostValue:[[dictionary objectForKey:@"instance_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"instance_date"];
    [request addPostValue:[[dictionary objectForKey:@"location_other"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"location_other"];
    
    NSString *imageStringAfterCrop = [dictionary objectForKey:@"image_path"];
    if(!([imageStringAfterCrop isEqualToString:@""]) && imageStringAfterCrop != nil)
    {
        [request addPostValue:[[dictionary objectForKey:@"image_path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"image_path"];
    }
    [request setRequestMethod:@"POST"];
    
    [request setDidFinishSelector:@selector(editEventResponse:)];
    [request startAsynchronous];
    
}

- (void) deleteEventsResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEventsSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEventsFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEventsFailed object:dictionary];
    }
}

- (void) callDeleteEventsWebService:(NSDictionary *)dictionary{
    
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=delete", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"DELETE"];
    
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"id"];
    [request addPostValue:[[dictionary objectForKey:@"type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"type"];
    
    [request setDidFinishSelector:@selector(deleteEventsResponse:)];
    [request startAsynchronous];
}



- (void) deleteEventsFromEventViewControllerResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEventsFromEventViewControllerSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEventsFromEventViewControllerFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEventsFailed object:dictionary];
    }
}

- (void) callDeleteEventsFromEventViewControllerWebService:(NSDictionary *)dictionary{
    
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_event.php?action=delete", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    [request addPostValue:[[dictionary objectForKey:@"type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"type"];
    [request addPostValue:[[dictionary objectForKey:@"id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"id"];
    [request setDidFinishSelector:@selector(deleteEventsFromEventViewControllerResponse:)];
    [request startAsynchronous];
}

- (void) getUserProfileResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileFailed object:dictionary];
    }
}

- (void) callGetUserProfileDataWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=profile", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request setDidFinishSelector:@selector(getUserProfileResponse:)];
    [request startAsynchronous];
}


- (void) getUserProfileForMasterTableResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileForMasterTableSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileForMasterTableFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserProfileForMasterTableFailed object:dictionary];
    }
}

- (void) callUserProfileForMasterTable:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=profile", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request setDidFinishSelector:@selector(getUserProfileForMasterTableResponse:)];
    [request startAsynchronous];
}

- (void) setMyAvalabilityResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSetAvailabilitySuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSetAvailabilityFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSetAvailabilityFailed object:dictionary];
    }
}

- (void) callSetMyAvalabilityWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_business.php?action=setavailability", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    
    [request addPostValue:[[dictionary objectForKey:kUserId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kUserId];
    [request addPostValue:[[dictionary objectForKey:kBoidId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kBoidId];
    [request addPostValue:[[dictionary objectForKey:@"from_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"from_date"];
    [request addPostValue:[[dictionary objectForKey:@"to_date"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"to_date"];
    
    [request addPostValue:[[dictionary objectForKey:@"mon_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"mon_start"];
    [request addPostValue:[[dictionary objectForKey:@"tue_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"tue_start"];
    [request addPostValue:[[dictionary objectForKey:@"wed_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"wed_start"];
    [request addPostValue:[[dictionary objectForKey:@"thu_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"thu_start"];
    [request addPostValue:[[dictionary objectForKey:@"fri_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"fri_start"];
    [request addPostValue:[[dictionary objectForKey:@"sat_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"sat_start"];
    [request addPostValue:[[dictionary objectForKey:@"sun_start"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"sun_start"];
    
    [request addPostValue:[[dictionary objectForKey:@"mon_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"mon_end"];
    [request addPostValue:[[dictionary objectForKey:@"tue_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"tue_end"];
    [request addPostValue:[[dictionary objectForKey:@"wed_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"wed_end"];
    [request addPostValue:[[dictionary objectForKey:@"thu_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"thu_end"];
    [request addPostValue:[[dictionary objectForKey:@"fri_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"fri_end"];
    [request addPostValue:[[dictionary objectForKey:@"sat_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"sat_end"];
    [request addPostValue:[[dictionary objectForKey:@"sun_end"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"sun_end"];
    
    [request setRequestMethod:@"POST"];
    
    [request setDidFinishSelector:@selector(setMyAvalabilityResponse:)];
    [request startAsynchronous];
}


- (void) getMyAvalabilityResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetAvailabilitySuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetAvailabilityFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetAvailabilityFailed object:dictionary];
    }
}

- (void) callGetMyAvalabilityWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_business.php?action=myavailability&userid=%@&boid=%@", kPlanitSyncitURL,[dictionary objectForKey:kUserId],[dictionary objectForKey:kBoidId]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request setDidFinishSelector:@selector(getMyAvalabilityResponse:)];
    [request startAsynchronous];
}


- (void) getListOfRosterResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfRosterSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfRosterFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetListOfRosterFailed object:dictionary];
    }
}

- (void) callGetListOfRosterWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_business.php?action=myroster&userid=%@&boid=%@&past=%@", kPlanitSyncitURL,[dictionary objectForKey:kUserId],[dictionary objectForKey:kBoidId],[dictionary objectForKey:@"past"]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request setDidFinishSelector:@selector(getListOfRosterResponse:)];
    [request startAsynchronous];
}


- (void) setRequestCancelResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSetRequestCancelSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSetRequestCancelFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSetRequestCancelFailed object:dictionary];
    }
}

- (void) callSetRequestCancelWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_business.php?action=requestcancel", kPlanitSyncitURL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:[[dictionary objectForKey:@"id"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"id"];
    [request addPostValue:[[dictionary objectForKey:@"boid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"boid"];
    [request addPostValue:[[dictionary objectForKey:@"msg"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"msg"];
    
    [request setRequestMethod:@"POST"];
    
    [request setDidFinishSelector:@selector(setRequestCancelResponse:)];
    [request startAsynchronous];
}


- (void) getListMyAvalabilityResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetMyAvailabilitySuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetMyAvailabilityFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetMyAvailabilityFailed object:dictionary];
    }
}

- (void) callGetListMyAvalabilityWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices_business.php?action=myavailability", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    
    [request addPostValue:[[dictionary objectForKey:kUserId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kUserId];
    [request addPostValue:[[dictionary objectForKey:kBoidId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kBoidId];
    
    [request setRequestMethod:@"GET"];
    
    [request setDidFinishSelector:@selector(getListMyAvalabilityResponse:)];
    [request startAsynchronous];
}

- (void) editProfileResponse:(ASIFormDataRequest *)request{
    NSString *response = [[request responseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditProfileSuccess object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditProfileFailed object:dictionary];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEditProfileFailed object:dictionary];
    }
}

- (void) callEditProfileWebService:(NSDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@/webservices.php?action=updateprof", kPlanitSyncitURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setDelegate:self];
    [request addPostValue:[[dictionary objectForKey:@"userid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userid"];
    
    [request addPostValue:[[dictionary objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"name"];
    
    [request addPostValue:[[dictionary objectForKey:@"phone"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"phone"];
    [request addPostValue:[[dictionary objectForKey:@"address"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"address"];
    [request addPostValue:[[dictionary objectForKey:@"zip"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"zip"];
    [request addPostValue:[[dictionary objectForKey:@"dob"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"dob"];
    [request addPostValue:[[dictionary objectForKey:@"gender"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"gender"];
    [request addPostValue:[[dictionary objectForKey:@"twitter"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"twitter"];
    [request addPostValue:[[dictionary objectForKey:@"facebook"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"facebook"];
    [request addPostValue:[[dictionary objectForKey:@"gplus"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"gplus"];
    [request addPostValue:[[dictionary objectForKey:@"linkedin"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"linkedin"];
    [request addPostValue:[[dictionary objectForKey:@"skype"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"skype"];
    [request addPostValue:[[dictionary objectForKey:@"instagram"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"instagram"];
    [request setStringEncoding:NSUTF8StringEncoding];
    
    NSString *imageStringAfterCrop = [dictionary objectForKey:@"image"];
    if(!([imageStringAfterCrop isEqualToString:@""]) && imageStringAfterCrop != nil)
    {
        [request addPostValue:[[dictionary objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"image"];
    }
    [request setRequestMethod:@"POST"];
    
    [request setDidFinishSelector:@selector(editProfileResponse:)];
    [request startAsynchronous];
    
}

- (void) finishedMatchListResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFinishedMatchFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kFinishedMatchSuccess object:dictionary];
        }
    }
}

- (void) callGetFinishedMatchListWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/get-finished-match-list.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:[[dictionary objectForKey:ktxtUserId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtUserId];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request setDidFinishSelector:@selector(finishedMatchListResponse:)];
    [request startAsynchronous];
}

- (void) saveMatchPointResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSaveMatchPointFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSaveMatchPointSuccess object:dictionary];
        }
    }
}


- (void) callSaveMatchPointWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-points-to-team.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"INSERT-UPDATE" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtMatchId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtMatchId];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request addPostValue:[[dictionary objectForKey:ktxtPointId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtPointId];
    [request addPostValue:[[dictionary objectForKey:ktxtHomeTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHomeTeamId];
    [request addPostValue:[[dictionary objectForKey:ktxtHTGoal] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTGoal];
    [request addPostValue:[[dictionary objectForKey:ktxtHTAssist] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTAssist];
    [request addPostValue:[[dictionary objectForKey:ktxtHTRedCard] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTRedCard];
    [request addPostValue:[[dictionary objectForKey:ktxtHTYellowPoint] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTYellowPoint];
    [request addPostValue:[[dictionary objectForKey:ktxtHTPoints] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTPoints];
    [request addPostValue:[[dictionary objectForKey:ktxtAwayTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtAwayTeamId];
    [request addPostValue:[[dictionary objectForKey:ktxtATGoal] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtATGoal];
    [request addPostValue:[[dictionary objectForKey:ktxtATAssist] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtATAssist];
    [request addPostValue:[[dictionary objectForKey:ktxtATRedCard] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtATRedCard];
    [request addPostValue:[[dictionary objectForKey:ktxtATYellowPoint] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtATYellowPoint];
    [request addPostValue:[[dictionary objectForKey:ktxtATPoints] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtATPoints];
    [request addPostValue:[[dictionary objectForKey:ktxtMatchStatus] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtMatchStatus];
    [request addPostValue:[[dictionary objectForKey:ktxtWonTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtWonTeamId];
    [request addPostValue:[[dictionary objectForKey:ktxtRemarks] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtRemarks];
    [request setDidFinishSelector:@selector(saveMatchPointResponse:)];
    [request startAsynchronous];
}

- (void) selectMatchPointResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectMatchPointFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectMatchPointSuccess object:dictionary];
        }
    }
}


- (void) callSelectMatchPointWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-points-to-team.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"SELECT" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtMatchId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtMatchId];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request setDidFinishSelector:@selector(selectMatchPointResponse:)];
    [request startAsynchronous];
}

- (void) savePlayerPointResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSavePlayerPointFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSavePlayerPointSuccess object:dictionary];
        }
    }
}

- (void) callSavePlayerPointWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-points-to-player.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"INSERT-UPDATE" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtMatchId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtMatchId];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request addPostValue:[[dictionary objectForKey:ktxtPointId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtPointId];
    [request addPostValue:[[dictionary objectForKey:ktxtTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtTeamId];
    [request addPostValue:[[dictionary objectForKey:ktxtHTGoal] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTGoal];
    [request addPostValue:[[dictionary objectForKey:ktxtHTAssist] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTAssist];
    [request addPostValue:[[dictionary objectForKey:ktxtHTRedCard] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTRedCard];
    [request addPostValue:[[dictionary objectForKey:ktxtHTYellowPoint] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTYellowPoint];
    [request addPostValue:[[dictionary objectForKey:ktxtHTPoints] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHTPoints];
    [request addPostValue:[[dictionary objectForKey:ktxtRemarks] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtRemarks];
    [request addPostValue:[[dictionary objectForKey:ktxtPlayerId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtPlayerId];
    [request setDidFinishSelector:@selector(savePlayerPointResponse:)];
    [request startAsynchronous];
}

- (void) selectPlayerPointResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPlayerPointFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPlayerPointSuccess object:dictionary];
        }
    }
}

- (void) callSelectPlayerPointWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-points-to-player.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"SELECT" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtHomeTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtHomeTeamId];
    [request addPostValue:[[dictionary objectForKey:ktxtAwayTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtAwayTeamId];
    [request setDidFinishSelector:@selector(selectPlayerPointResponse:)];
    [request startAsynchronous];
}

- (void) playerStandingListResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerStandingListFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerStandingListSuccess object:dictionary];
        }
    }
}

- (void) callPlayerStandingListWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/player-standing.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"SELECT" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request setDidFinishSelector:@selector(playerStandingListResponse:)];
    [request startAsynchronous];
}

- (void) leaugeWiseTeamListResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeaugeWiseTeamListFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeaugeWiseTeamListSuccess object:dictionary];
        }
    }
}

- (void) callLeaugeWiseTeamListWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/leaguewise-team-list.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request setDidFinishSelector:@selector(leaugeWiseTeamListResponse:)];
    [request startAsynchronous];
}

- (void) teamWiseUpcomingMatchResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTeamWiseUpcomingMatchFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kTeamWiseUpcomingMatchSuccess object:dictionary];
        }
    }
}

- (void) callTeamWiseUpcomingMatchWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/team-wise-upcoming-matches.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request addPostValue:[[dictionary objectForKey:ktxtTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtTeamId];
    [request setDidFinishSelector:@selector(teamWiseUpcomingMatchResponse:)];
    [request startAsynchronous];
}
- (void) commentsOnMatchByPlayerResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCommentsOnMatchByPlayerFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kCommentsOnMatchByPlayerSuccess object:dictionary];
        }
    }
}

- (void) callCommentsOnMatchByPlayerWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-comments-to-match.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"INSERT-UPDATE" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request addPostValue:[[dictionary objectForKey:ktxtMatchId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtMatchId];
    [request addPostValue:[[dictionary objectForKey:ktxtUserId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtUserId];
    [request addPostValue:[[dictionary objectForKey:ktxtComment] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtComment];
    [request addPostValue:[[dictionary objectForKey:ktxtCommentId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtCommentId];
    [request setDidFinishSelector:@selector(commentsOnMatchByPlayerResponse:)];
    [request startAsynchronous];
}

- (void) deleteCommentResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteCommentFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteCommentSuccess object:dictionary];
        }
    }
}

- (void) callDeleteCommentsWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-comments-to-match.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"DELETE" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtCommentId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtCommentId];
    [request setDidFinishSelector:@selector(deleteCommentResponse:)];
    [request startAsynchronous];
}

- (void) selectCommentResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectCommentFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectCommentSuccess object:dictionary];
        }
    }
}

- (void) callSelectCommentWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-comments-to-match.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"SELECT" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtUserId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtUserId];
    [request setDidFinishSelector:@selector(selectCommentResponse:)];
    [request startAsynchronous];
}

- (void) voteForPlayerResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kVoteForPlayerFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kVoteForPlayerSuccess object:dictionary];
        }
    }
}

- (void) callVoteForPlayerWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-vote-for-player.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"INSERT-UPDATE" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request addPostValue:[[dictionary objectForKey:ktxtMatchId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtMatchId];
    [request addPostValue:[[dictionary objectForKey:ktxtUserId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtUserId];
    [request addPostValue:[[dictionary objectForKey:ktxtVoteForPlayerId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtVoteForPlayerId];
    [request addPostValue:[[dictionary objectForKey:ktxtVoteId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtVoteId];
    [request setDidFinishSelector:@selector(voteForPlayerResponse:)];
    [request startAsynchronous];
}

- (void) deleteVoteResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteVoteFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteVoteSuccess object:dictionary];
        }
    }
}

- (void) callDeleteVoteWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/add-vote-for-player.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"DELETE" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtVoteId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtVoteId];
    [request setDidFinishSelector:@selector(deleteVoteResponse:)];
    [request startAsynchronous];
}

- (void) getSelectedTeamResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetSelectedTeamFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetSelectedTeamSuccess object:dictionary];
        }
    }
}

- (void) callGetSelectedteamForSelectedMatchWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"http://soccerapp.astrowow.com/webservice/get-selected-team-by-match.php?txtMatchId=%@&txtLeagueId=%@&txtTeamId=%@",[dictionary objectForKey:ktxtMatchId],[dictionary objectForKey:ktxtLeagueId],[dictionary objectForKey:ktxtTeamId]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getSelectedTeamResponse:)];
    [request startAsynchronous];
}

- (void) selectPlayerListResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPlayerListFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPlayerListSuccess object:dictionary];
        }
    }
}

- (void) callSelectPlayerListWebService:(NSDictionary *)dictionary{
    NSString *url = [NSString stringWithFormat:@"http://soccerapp.astrowow.com/webservice/get-playerlist-for-vote.php?txtLeagueId=%@",[dictionary objectForKey:ktxtLeagueId]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(selectPlayerListResponse:)];
    [request startAsynchronous];
}

- (void) teamStandingResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTeamStandingFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kTeamStandingSuccess object:dictionary];
        }
    }
}


- (void) callTeamStaningWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/team-standing.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request addPostValue:@"SELECT" forKey:kCRUDMethod];
    [request setDidFinishSelector:@selector(teamStandingResponse:)];
    [request startAsynchronous];
}

- (void) previousMatchResponse:(ASIFormDataRequest *)request{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingMutableContainers error: nil];
    if(dictionary){
        NSDictionary *dict;
        if([[dictionary objectForKey:@"meta"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray");
            
        }
        else if ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]]){
            dict = [dictionary objectForKey:@"meta"];
            
        }
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        NSLog(@"Responce =  %@",str);
        if([str isEqualToString:@"success"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPreviousMatchFailed object:dictionary];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kPreviousMatchSuccess object:dictionary];
        }
    }
}

- (void) callPreviousMatchResultWebService:(NSDictionary *)dictionary{
    NSString *url = @"http://soccerapp.astrowow.com/webservice/previous-match-results.php";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request addPostValue:@"SELECT" forKey:kCRUDMethod];
    [request addPostValue:[[dictionary objectForKey:ktxtLeagueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtLeagueId];
    [request addPostValue:[[dictionary objectForKey:ktxtTeamId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:ktxtTeamId];
    [request setDidFinishSelector:@selector(previousMatchResponse:)];
    [request startAsynchronous];
}
@end
