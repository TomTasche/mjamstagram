/*
 * Copyright (c) 2012 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package com.google.cloud.demo.model;

import com.google.appengine.api.blobstore.BlobKey;

/**
 * The photo entity interface.
 *
 */
public interface Photo extends DemoEntity {
  Long getId();

  BlobKey getBlobKey();

  void setBlobKey(BlobKey blobKey);

  boolean isShared();

  void setShared(boolean shared);

  String getRestaurant();

  void setRestaurant(Restaurant restaurant);
  
  String getFood();

  void setFood(String food);

  String getOwnerNickname();

  void setOwnerNickname(String nickname);

  String getOwnerId();

  long getUploadTime();

  void setUploadTime(long uploadTime);

  boolean isActive();

  void setActive(boolean active);
}
