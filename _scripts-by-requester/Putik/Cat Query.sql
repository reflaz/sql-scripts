select 
catalog_simple.sku,
cat.level1,
cat.level2,
cat.level3,
cat.level4
from(
	select 
		catalog_config.id_catalog_config,
		ifnull(if(catalog_config.primary_category is not null, category_from_primary.id_catalog_category, category_not_from_primary.id_catalog_category),'') as id_catalog_category,
		if(catalog_config.primary_category is not null, category_from_primary.level1, category_not_from_primary.level1) as level1,
		if(catalog_config.primary_category is not null, category_from_primary.level2, category_not_from_primary.level2) as level2,
		if(catalog_config.primary_category is not null, category_from_primary.level3, category_not_from_primary.level3) as level3,
		if(catalog_config.primary_category is not null, category_from_primary.level4, category_not_from_primary.level4) as level4,
		if(catalog_config.primary_category is not null, category_from_primary.level5, category_not_from_primary.level5) as level5,
		if(catalog_config.primary_category is not null, category_from_primary.level6, category_not_from_primary.level6) as level6
	from catalog_config
	left outer join (
		select
			category_tree.id_catalog_category,
			substring_index(substring_index(category_tree.category_tree_string, ';separator;', 1), ';separator;', -1) as 'level1',
			if(substring_index(substring_index(category_tree.category_tree_string, ';separator;', 2), ';separator;', -1) <> substring_index(substring_index(category_tree.category_tree_string, ';separator;', 1), ';separator;', -1), substring_index(substring_index(category_tree.category_tree_string, ';separator;', 2), ';separator;', -1),'') as 'level2',
			if(substring_index(substring_index(category_tree.category_tree_string, ';separator;', 3), ';separator;', -1) <> substring_index(substring_index(category_tree.category_tree_string, ';separator;', 2), ';separator;', -1), substring_index(substring_index(category_tree.category_tree_string, ';separator;', 3), ';separator;', -1),'') as 'level3',
			if(substring_index(substring_index(category_tree.category_tree_string, ';separator;', 4), ';separator;', -1) <> substring_index(substring_index(category_tree.category_tree_string, ';separator;', 3), ';separator;', -1), substring_index(substring_index(category_tree.category_tree_string, ';separator;', 4), ';separator;', -1),'') as 'level4',
			if(substring_index(substring_index(category_tree.category_tree_string, ';separator;', 5), ';separator;', -1) <> substring_index(substring_index(category_tree.category_tree_string, ';separator;', 4), ';separator;', -1), substring_index(substring_index(category_tree.category_tree_string, ';separator;', 5), ';separator;', -1),'') as 'level5',
			if(substring_index(substring_index(category_tree.category_tree_string, ';separator;', 6), ';separator;', -1) <> substring_index(substring_index(category_tree.category_tree_string, ';separator;', 5), ';separator;', -1), substring_index(substring_index(category_tree.category_tree_string, ';separator;', 6), ';separator;', -1),'') as 'level6'
		from(
			select deepest.id_catalog_category,
				group_concat(catalog_category.name_en order by catalog_category.lft separator ';separator;') as category_tree_string
			from catalog_category as deepest
			inner join catalog_category
				on catalog_category.lft <= deepest.lft and deepest.rgt <= catalog_category.rgt
				and catalog_category.id_catalog_category > 1
				and catalog_category.regional_key <> ''
				and deepest.regional_key <> ''
				and catalog_category.status = 'active'
				and deepest.status = 'active'
			group by deepest.id_catalog_category
		) as category_tree
	) as category_from_primary on category_from_primary.id_catalog_category = catalog_config.primary_category
	left outer join (
		select 
			catalog_config.id_catalog_config,
			category_tree.id_catalog_category,
			ifnull(category_tree.level1, '') as level1,
			ifnull(category_tree.level2, '') as level2,
			ifnull(category_tree.level3, '') as level3,
			ifnull(category_tree.level4, '') as level4,
			ifnull(category_tree.level5, '') as level5,
			ifnull(category_tree.level6, '') as level6
		from catalog_config
		left outer join(
			select 
				catalog_config_has_catalog_category.fk_catalog_config, 
				catalog_category.id_catalog_category,
				if(catalog_category_deepest.lft > catalog_category.lft and catalog_category_deepest.rgt < catalog_category.rgt,0,1) as deepest
			from catalog_config_has_catalog_category
			inner join catalog_category
				on catalog_category.id_catalog_category = catalog_config_has_catalog_category.fk_catalog_category
				and catalog_category.status = 'active'
				and catalog_category.regional_key <> ''
				and catalog_category.id_catalog_category > 1
			inner join catalog_config_has_catalog_category as catalog_config_has_catalog_category_deepest
				on catalog_config_has_catalog_category.fk_catalog_config = catalog_config_has_catalog_category_deepest.fk_catalog_config
			left outer join catalog_category as catalog_category_deepest
				on catalog_category_deepest.id_catalog_category = catalog_config_has_catalog_category_deepest.fk_catalog_category
				and catalog_category_deepest.status = 'active'
				and catalog_category_deepest.regional_key <> ''
				and catalog_category_deepest.id_catalog_category > 1
			group by catalog_config_has_catalog_category.fk_catalog_config, catalog_category.id_catalog_category
			having sum(deepest) = count(*)
		) as deepest on deepest.fk_catalog_config = catalog_config.id_catalog_config
		left outer join (
		select
			id_catalog_category,
			substring_index(substring_index(category_temp.category_tree_string, ';separator;', 1), ';separator;', -1) as 'level1',
			if(substring_index(substring_index(category_temp.category_tree_string, ';separator;', 2), ';separator;', -1) <> substring_index(substring_index(category_temp.category_tree_string, ';separator;', 1), ';separator;', -1), substring_index(substring_index(category_temp.category_tree_string, ';separator;', 2), ';separator;', -1),'') as 'level2',
			if(substring_index(substring_index(category_temp.category_tree_string, ';separator;', 3), ';separator;', -1) <> substring_index(substring_index(category_temp.category_tree_string, ';separator;', 2), ';separator;', -1), substring_index(substring_index(category_temp.category_tree_string, ';separator;', 3), ';separator;', -1),'') as 'level3',
			if(substring_index(substring_index(category_temp.category_tree_string, ';separator;', 4), ';separator;', -1) <> substring_index(substring_index(category_temp.category_tree_string, ';separator;', 3), ';separator;', -1), substring_index(substring_index(category_temp.category_tree_string, ';separator;', 4), ';separator;', -1),'') as 'level4',
			if(substring_index(substring_index(category_temp.category_tree_string, ';separator;', 5), ';separator;', -1) <> substring_index(substring_index(category_temp.category_tree_string, ';separator;', 4), ';separator;', -1), substring_index(substring_index(category_temp.category_tree_string, ';separator;', 5), ';separator;', -1),'') as 'level5',
			if(substring_index(substring_index(category_temp.category_tree_string, ';separator;', 6), ';separator;', -1) <> substring_index(substring_index(category_temp.category_tree_string, ';separator;', 5), ';separator;', -1), substring_index(substring_index(category_temp.category_tree_string, ';separator;', 6), ';separator;', -1),'') as 'level6'
		from(
			select
				catalog_category.id_catalog_category,
				group_concat(father.name_en order by father.lft separator ';separator;') as category_tree_string
			from catalog_category
			inner join catalog_category as father
				on father.lft <= catalog_category.lft
				and father.rgt >= catalog_category.rgt
				and father.status = 'active'
				and catalog_category.status = 'active'
				and catalog_category.id_catalog_category > 1
				and father.id_catalog_category > 1
				and father.regional_key <> ''
				and catalog_category.regional_key <> ''
			group by catalog_category.id_catalog_category
			) as category_temp
		) as category_tree on category_tree.id_catalog_category = deepest.id_catalog_category
		group by catalog_config.id_catalog_config
	) as category_not_from_primary on category_not_from_primary.id_catalog_config = catalog_config.id_catalog_config
		and catalog_config.primary_category is null
) as cat
inner join catalog_simple
	on catalog_simple.fk_catalog_config = cat.id_catalog_config
	and catalog_simple.sku in (

	
	)