/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

#import "FBGraphObject.h"

/*!
 @protocol

 @abstract
 The `FBOpenGraphObject` protocol is the base protocol for use in posting and retrieving Open Graph objects.
 It inherits from the `FBGraphObject` protocol; you may derive custome protocols from `FBOpenGraphObject` in order
 implement typed access to your application's custom objects.

 @discussion
 Represents an Open Graph custom object, to be used directly, or from which to
 derive custom action protocols with custom properties.
 */
@protocol FBOpenGraphObject<FBGraphObject>

/*!
 @property
 @abstract Typed access to the object's id
 */
@property (retain, nonatomic) NSString              *id;

/*!
 @property
 @abstract Typed access to the object's type, which is a string in the form mynamespace:mytype
 */
@property (retain, nonatomic) NSString              *type;

/*!
 @property
 @abstract Typed access to object's title
 */
@property (retain, nonatomic) NSString              *title;

/*!
 @property
 @abstract Typed access to the object's image property
 */
@property (retain, nonatomic) id                    image;

/*!
 @property
 @abstract Typed access to the object's url property
 */
@property (retain, nonatomic) id                    url;

/*!
 @property
 @abstract Typed access to the object's description property
 */
@property (strong, nonatomic) id                    desc;

/*!
 @property
 @abstract Typed access to action's data, which is a dictionary of custom properties
 */
@property (retain, nonatomic) id<FBGraphObject>     data;

@end
