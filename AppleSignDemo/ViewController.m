//
//  ViewController.m
//  AppleSignDemo
//
//  Created by v on 2020/5/14.
//  Copyright © 2020 v. All rights reserved.
//

#import "ViewController.h"
@import AuthenticationServices;

@interface ViewController () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ASAuthorizationAppleIDButton *btn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
    [btn addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
}

- (void)signAction:(id)sender {
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeEmail, ASAuthorizationScopeFullName];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

#pragma mark - ASAuthorizationControllerDelegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    id <ASAuthorizationCredential> credential = authorization.credential;
    if ([credential isKindOfClass:ASAuthorizationAppleIDCredential.class]) {
        ASAuthorizationAppleIDCredential *appleIDCredential = credential;
        NSString *user = appleIDCredential.user;
        NSPersonNameComponents *fullName = appleIDCredential.fullName;
        NSString *email = appleIDCredential.email;
        NSString *token = [appleIDCredential.identityToken base64EncodedStringWithOptions:0];
        
        NSLog(@"user: %@\n"
              @"fullName: %@ %@\n"
              @"email: %@\n"
              @"token: %@", user, fullName.givenName, fullName.familyName, email, token);
    } else if ([credential isKindOfClass:ASPasswordCredential.class]) {
        ASPasswordCredential *passwordCredential = credential;
        NSString *user = passwordCredential.user;
        NSString *password = passwordCredential.password;
        NSLog(@"user: %@\n"
              @"password: %@", user, password);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSLog(@"sign fail: %@", error);
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return self.view.window;
}

@end
