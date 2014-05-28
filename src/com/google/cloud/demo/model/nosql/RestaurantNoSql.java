/* Copyright (c) 2012 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.cloud.demo.model.nosql;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.cloud.demo.model.Restaurant;

public class RestaurantNoSql extends DemoEntityNoSql implements Restaurant {
	public static final String FIELD_NAME_NAME = "name";
	public static final String FIELD_NAME_URL = "url";

	public RestaurantNoSql(Entity entity) {
		super(entity);
	}

	public RestaurantNoSql(Key parentKey, String kind) {
		super(parentKey, kind);
	}

	public static final String getKind() {
		return Restaurant.class.getSimpleName();
	}

	@Override
	public String getName() {
		return (String) entity.getProperty(FIELD_NAME_NAME);
	}

	@Override
	public String getUrl() {
		return (String) entity.getProperty(FIELD_NAME_URL);
	}

	@Override
	public void setName(String name) {
		entity.setProperty(FIELD_NAME_NAME, name);
	}

	@Override
	public void setUrl(String url) {
		entity.setProperty(FIELD_NAME_URL, url);
	}

	@Override
	public Long getId() {
		return entity.getKey().getId();
	}
}
