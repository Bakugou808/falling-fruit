function data_link(){
  var muni = $('#muni').is(':checked'); 
  var bounds = map.getBounds();
  var bstr = 'nelat=' + bounds.getNorthEast().lat() + '&nelng=' + bounds.getNorthEast().lng() +
         '&swlat=' + bounds.getSouthWest().lat() + '&swlng=' + bounds.getSouthWest().lng();
  var mstr = 0;
  if(muni) mstr = 1;
  return '/locations/data.csv?muni=' + mstr + '&' + bstr;
}

function update_permalink(){
  var center = map.getCenter();
  var typeid = map.getMapTypeId();
  var zoom = map.getZoom();
  $('#permalink').attr('href','/?z=' + zoom + '&y=' + sprintf('%.05f',center.lat()) +
    '&x=' + sprintf('%.05f',center.lng()) + '&m=' + $('#muni').is(":checked") + "&t=" + typeid);
}

function update_display(force,force_zoom){
  var zoom = map.getZoom();
  if(force_zoom != undefined) zoom = force_zoom;
  var bounds = map.getBounds();
  var center = map.getCenter();
  update_permalink();
  if(prior_bounds == null && prior_zoom == null && zoom <= 12){
    $('#hidden_controls').hide();
    $('#export_data').hide();
    do_clusters(undefined,zoom,$('#muni').is(':checked'));
    prior_zoom = zoom;
    prior_bounds = bounds;
  }
  if(zoom <= 12){
    if((zoom != prior_zoom) || force){
      $('#hidden_controls').hide();
      $('#export_data').hide();
      do_clusters(undefined,zoom,$('#muni').is(':checked'));
    }
  }else if(zoom >= 13){
    $('#get_data_link').attr('href',data_link());
    $('#hidden_controls').show();
    $('#export_data').show();
    do_markers(bounds,null,$('#muni').is(':checked'));
  }
  prior_zoom = zoom;
  prior_bounds = bounds;
}
