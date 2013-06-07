class SetupClusters < ActiveRecord::Migration
  def up
    change_table :clusters do |t| 
    end
    
    earth_radius = 6378137.0
    gsize_init = 2.0*Math::PI*earth_radius
    xo = -gsize_init/2.0
    yo = gsize_init/2.0
    (0..12).each{ |z|
      gsize = gsize_init/(2.0**z)
      execute <<-SQL
      
      INSERT INTO clusters (method,muni,zoom,grid_size,count,cluster_point,grid_point,polygon,created_at,updated_at) 
       SELECT 'grid' as method, 'f' as muni, #{z} as zoom, #{gsize} as grid_size, count, cluster_point, grid_point,
       st_setsrid(st_makebox2d(st_translate(grid_point,-#{gsize}/2,-#{gsize}/2), st_translate(grid_point,#{gsize}/2,#{gsize}/2)),900913) as polygon, 
       NOW() as created_at, NOW() as updated_at FROM
       (SELECT count(location) as count, st_centroid(st_transform(st_collect(st_setsrid(location::geometry,4326)),900913)) as cluster_point,
       st_snaptogrid(st_transform(st_setsrid(location::geometry,4326),900913),#{xo}+#{gsize}/2,#{yo}-#{gsize}/2,#{gsize},#{gsize}) as grid_point
       FROM locations WHERE lng IS NOT NULL and lat IS NOT NULL AND (import_id IS NULL OR
       import_id IN (SELECT id FROM imports WHERE NOT muni)) GROUP BY grid_point) AS subq;

      INSERT INTO clusters (method,muni,zoom,grid_size,count,cluster_point,grid_point,polygon,created_at,updated_at) 
       SELECT 'grid' as method, 't' as muni, #{z} as zoom, #{gsize} as grid_size, count, cluster_point, grid_point,
       st_setsrid(st_makebox2d(st_translate(grid_point,-#{gsize}/2,-#{gsize}/2), st_translate(grid_point,#{gsize}/2,#{gsize}/2)),900913) as polygon, 
       NOW() as created_at, NOW() as updated_at FROM
       (SELECT count(location) as count, st_centroid(st_transform(st_collect(location::geometry),900913)) as cluster_point,
       st_snaptogrid(st_transform(st_setsrid(location::geometry,4326),900913),#{xo}+#{gsize}/2,#{yo}-#{gsize}/2,#{gsize},#{gsize}) as grid_point
       FROM locations WHERE lng IS NOT NULL and lat IS NOT NULL AND (import_id IS NULL OR
       import_id IN (SELECT id FROM imports WHERE muni)) GROUP BY grid_point) AS subq;
      SQL
    }
  end

  def down
    execute "TRUNCATE clusters;"
  end
end
