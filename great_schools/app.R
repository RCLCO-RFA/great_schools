library(shiny)
library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(sf)

for(f in list.files('./functions/', full.names = T)){
    source(f)
}

# https://bhaskarvk.github.io/leaflet.extras/reference/draw-options.html

#test with some data
school_test


# Crop 'r' when action button is pressed
ui <- fluidPage(
               textInput('shape_name', 'Shape Name'),
               actionButton("submit_shape_name", "Submit Shape Name"),
               leaflet::leafletOutput('schools_map'),
               actionButton("submit_custom_polygon", "Submit Custom Polygon"),
               # textOutput("poly"),
               DT::DTOutput("schools_table")
)

server <- function(input, output, session) {
    
    #initial map
    output$schools_map = renderLeaflet({
        leaflet::leaflet() %>%
            leaflet::addTiles() %>%
            leaflet::setView(lng = -106.8583795, lat = 40.4766772, zoom = 4) %>%
            leaflet.extras::addDrawToolbar(polylineOptions = F,
                                           circleOptions = F,
                                           markerOptions = F,
                                           circleMarkerOptions = F,
                                           rectangleOptions = F,
                                           polygonOptions=drawPolygonOptions(showArea=TRUE,
                                                                             metric = FALSE,
                                                                             shapeOptions = drawShapeOptions(lineCap = NULL)),
                                           # drawPolygonOptions(showArea = TRUE, metric = FALSE,
                                           #                    shapeOptions = drawShapeOptions(), repeatMode = FALSE),
                                           editOptions = editToolbarOptions(edit = F,
                                                                            remove = T))
        
    })
    
    #empty shape and name reactive objects
    poly_rv <- reactiveVal(NULL)
    shape_name_rv <- reactiveVal(NULL)
    schools_rv <- reactiveVal(NULL)
    
    #observe shape name submit & store
    observeEvent(input$submit_shape_name, {
        shape_name <- as.character(input$shape_name)
        shape_name_rv(shape_name)
        print(shape_name_rv)
    })
    
    
    # observeEvent(input$map_draw_new_feature, {
    #     feat <- input$map_draw_new_feature
    #     coords <- unlist(feat$geometry$coordinates)
    #     coords <- matrix(coords, ncol = 2, byrow = T)
    #     poly <- st_sf(st_sfc(st_polygon(list(coords))), crs = st_crs(4326))
    #     #reactive to polygon drawn
    #     poly_rv(poly)
    # })
    # 
    
    observeEvent(input$schools_map_draw_all_features, {
        observed_data = input$schools_map_draw_all_features
        print("Object Drawn:")

        if(observed_data$features[[1]]$geometry$type == "Polygon"){
            poly_string = convert_to_polygon_string(observed_data$features[[1]]$geometry) #what is this function?
            print("Poly String!")
            poly_rv(poly_string)
        }
        else{
            print("User drew something other than a polygon")
        }

        #extract polygon sf
        # feat <- input$schools_map_draw_new_feature
        # coords <- unlist(feat$geometry$coordinates)
        # coords <- matrix(coords, ncol = 2, byrow = T)
        # print(coords)
        # 
        # poly <- sf::st_sf(sf::st_sfc(sf::st_polygon(list(coords))), crs = sf::st_crs(4326))
        # print("Polygon SF object created")
        # poly_rv(poly)
    })
    
    output$poly <- renderPrint({
        req(poly_rv())
        poly_rv()
    })
    
    
    observeEvent(input$submit_custom_polygon, {
        #reactives to flow in
        if(is.null(shape_name_rv())){shiny::showNotification("Enter a shape name and submit that first!")}
        if(is.null(poly_rv())){shiny::showNotification("Please draw a complete polygon first!")}
        req(shape_name_rv())
        req(poly_rv())
        
        
        get_shape_name <- shape_name_rv()
        get_poly <- poly_rv()
        
        #send shape to database with the name
        httr::POST(rclcoData::build_api_url('custom_shapes/custom_shape_create/'),
                   body = list(overlay_name = get_shape_name,
                               geometry = get_poly), #how to get this to work
                   encode = 'json'
        )

        Sys.sleep(1)
        print(paste0("Polygon called ",get_shape_name," sent to database...loading schools data"))
        
        #This finds the shape in the database, spatial joins with great schools, if data does not exist for those zip codes, it queries the great schools api
        api_url = rclcoData::build_api_url(paste0('great_schools/great_schools?custom_shape=', get_shape_name))
        Sys.sleep(1)
        schools_df = sf::st_read(api_url)
        schools_rv(schools_df)
        print(schools_rv())
        
        #update map with schools
        map_new <- leaflet::leafletProxy("schools_map", session = session)
        map_new %>%
            leaflet::clearMarkers() %>%
            leaflet::clearShapes() %>%
            leaflet::clearControls() %>%
            leaflet.extras::removeDrawToolbar() %>% #toolbar doesn't clear?
            leaflet::addCircleMarkers(data = schools_rv(),
                                      fillColor = "black",
                                      radius = 1,
                                      label = ~name)
        
    })
    
    #schools table
    output$schools_table = DT::renderDT({
        DT::datatable(schools_rv() %>%
                          dplyr::select(c("name", "type", "level-codes", "level", "street", "city", "state", "lat", "lon",
                                          "district-name", "rating", "year")) %>%
                          sf::st_drop_geometry(),
                      rownames = FALSE,
                      options = list(searching = FALSE, pageLength = 10))
        # colnames = c("School", "Type", "Grades"))
    })
    

    
}

shinyApp(ui, server)