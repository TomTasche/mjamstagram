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
package com.google.cloud.demo.model.nosql;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.cloud.demo.model.Restaurant;
import com.google.cloud.demo.model.RestaurantManager;

/**
 * Entity manager class to support comment datastore operations.
 * 
 */
public class RestaurantManagerNoSql extends DemoEntityManagerNoSql<Restaurant>
		implements RestaurantManager {

	public RestaurantManagerNoSql() {
		super(Restaurant.class);
	}

	@Override
	public Restaurant getRestaurant(String url) {
		Query query = new Query(getKind());
		Query.Filter urlFilter = new Query.FilterPredicate(
				RestaurantNoSql.FIELD_NAME_URL, FilterOperator.EQUAL, url);
		query.setFilter(urlFilter);

		FetchOptions options = FetchOptions.Builder.withDefaults();
		Iterable<Restaurant> result = queryEntities(query, options);
		if (result.iterator().hasNext()) {
			return result.iterator().next();
		} else {
			return null;
		}
	}

	@Override
	public Restaurant getRestaurant(Long id) {
		return getEntity(KeyFactory.createKey(getKind(), id));
	}

	@Override
	public Restaurant newRestaurant() {
		return new RestaurantNoSql(getKind());
	}

	@Override
	protected Restaurant fromParentKey(Key parentKey) {
		throw new RuntimeException("not implemented");
	}

	@Override
	protected Restaurant fromEntity(Entity entity) {
		return new RestaurantNoSql(entity);
	}
}
