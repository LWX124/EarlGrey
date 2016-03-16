//
// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FTRBaseIntegrationTest.h"

#import "FTRAccessibleView.h"

@interface FTRMatcherTest : FTRBaseIntegrationTest
@end

@implementation FTRMatcherTest

- (void)testDescendantMatcherWithBasicViews {
  [self openTestViewNamed:@"Basic Views"];

  id<GREYMatcher> matchesAccessibleViewParentOfSimpleLabel =
      grey_allOf(grey_descendant(grey_accessibilityLabel(@"Simple Label")),
               grey_accessibilityLabel(@"tab2Container"),
               nil);

  [[EarlGrey selectElementWithMatcher:matchesAccessibleViewParentOfSimpleLabel]
      assertWithMatcher:grey_notNil()];

  id<GREYMatcher> matchesChildOfParentOfSimpleLabel =
      grey_allOf(grey_ancestor(matchesAccessibleViewParentOfSimpleLabel),
                 grey_kindOfClass([UISwitch class]),
                 nil);
  [[EarlGrey selectElementWithMatcher:matchesChildOfParentOfSimpleLabel]
      assertWithMatcher:grey_accessibilityLabel(@"Switch")];
}

- (void)testUserInteractionEnabledMatcherForBasicView {
  [self openTestViewNamed:@"Basic Views"];

  [[EarlGrey selectElementWithMatcher:grey_text(@"Tab 2")] performAction:grey_tap()];

  // Simple Label has user interaction enabled set to NO in xib.
  [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(@"Simple Label")]
      assertWithMatcher:grey_not(grey_userInteractionEnabled())];

  [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(@"Switch")]
      assertWithMatcher:grey_userInteractionEnabled()];
}

- (void)testDescendantMatcherWithTableViews {
  [self openTestViewNamed:@"Table Views"];

  id<GREYMatcher> descendantRowMatcher = grey_allOf(grey_kindOfClass([UITableViewCell class]),
                                                grey_descendant(grey_accessibilityLabel(@"Row 1")),
                                                nil);

  [[EarlGrey selectElementWithMatcher:descendantRowMatcher] assertWithMatcher:grey_notNil()];
}

-(void)testDescendantMatcherWithAccessibilityViews {
  [self openTestViewNamed:@"Accessibility Views"];

  id<GREYMatcher> matchesParentOfSquare =
      grey_allOf(grey_descendant(grey_accessibilityValue(@"SquareElementValue")),
               grey_kindOfClass([FTRAccessibleView class]),
               nil);

  [[EarlGrey selectElementWithMatcher:matchesParentOfSquare]
      assertWithMatcher:grey_descendant(grey_accessibilityLabel(@"SquareElementLabel"))];
}

@end
