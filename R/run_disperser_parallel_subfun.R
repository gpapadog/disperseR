#' @export get_output_df

#########################################################
################# get_output_df

get_output_df <- function(model) {
  if (inherits(model, "traj_model")) {
    if (is.null(model$traj_df)) {
      return(NA)
    }

    if (!is.null(model$traj_df)) {
      return(dplyr::as.tbl(model$traj_df))
    }
  }

  if (inherits(model, "disp_model")) {
    if (is.null(model$disp_df)) {
      return(NA)
    }

    if (!is.null(model$disp_df)) {
      return(dplyr::as.tbl(model$disp_df))
    }
  }
}

#########################################################
################# dispersion_read

#' @export dispersion_read
dispersion_read <- function(archive_folder) {
  dispersion_file_list <-
    list.files(path = archive_folder,
      pattern = "^GIS_part_[0-9][0-9][0-9]_ps.csv",
      full.names = TRUE)

  # Get each CSV file into a single data frame
  for (i in 1:length(dispersion_file_list)) {
    if (i == 1) {
      dispersion <-
        as.data.frame(mat.or.vec(nr = 0, nc = 5))
      colnames(dispersion) <-
        c("particle_no", "lon", "lat",
          "height", "hour")
    }
    disp <-
      read.csv(dispersion_file_list[i], header = FALSE)
    colnames(disp) <-
      c("particle_no", "lon", "lat", "height")
    disp$hour <- i
    dispersion <- rbind(dispersion, disp)
  }

  # Return the data frame
  return(dispersion)
}

#########################################################
################# add_params

#' @export add_params
add_params <- function(model,
  lat = NULL,
  lon = NULL,
  height = NULL,
  duration = NULL,
  run_period = NULL,
  start_day = NULL,
  start_hour = NULL,
  daily_hours = NULL,
  direction = NULL,
  met_type = NULL,
  vert_motion = NULL,
  model_height = NULL,
  traj_name = NULL,
  exec_dir = NULL,
  met_dir = NULL,
  binary_path = NULL) {
  if (!is.null(lat)) {
    model$lat <- lat
  }

  if (!is.null(lon)) {
    model$lon <- lon
  }

  if (!is.null(height)) {
    model$height <- height
  }

  if (!is.null(duration)) {
    model$duration <- duration
  }

  if (!is.null(run_period)) {
    model$run_period <- run_period
  }

  if (!is.null(start_day)) {
    model$start_day <- start_day
  }

  if (!is.null(start_hour)) {
    model$start_hour <- start_hour
  }

  if (!is.null(daily_hours)) {
    model$daily_hours <- daily_hours
  }

  if (!is.null(direction)) {
    model$direction <- direction
  }

  if (!is.null(met_type)) {
    model$met_type <- met_type
  }

  if (!is.null(vert_motion)) {
    model$vert_motion <- vert_motion
  }

  if (!is.null(model_height)) {
    model$model_height <- model_height
  }

  if (!is.null(traj_name)) {
    model$traj_name <- traj_name
  }

  if (!is.null(exec_dir)) {
    model$exec_dir <- exec_dir
  }

  if (!is.null(met_dir)) {
    model$met_dir <- met_dir
  }

  if (!is.null(binary_path)) {
    model$binary_path <- binary_path
  }

  return(model)
}

#########################################################
################# create_disp_model
#' @export create_disp_model
# Create the 'disp_model' list object
create_disp_model <- function(name = NULL) {
  # Create the 'disp_model' list object
  disp_model <-
    list(
      disp_name = NULL,
      lat = NULL,
      lon = NULL,
      height = NULL,
      duration = NULL,
      start_day = NULL,
      start_hour = NULL,
      direction = "forward",
      met_type = NULL,
      emissions = NULL,
      species = NULL,
      grids = NULL,
      vert_motion = 0,
      model_height = 20000,
      disp_df = NULL
    )

  attr(disp_model, "class") <- "disp_model"

  if (!is.null(name))
    disp_model$disp_name <- name

  return(disp_model)
}


#########################################################
################# add_species
#' @export add_species
add_species <- function(model,
  name = NULL,
  pdiam = NULL,
  density = NULL,
  shape_factor = NULL,
  ddep_vel = NULL,
  ddep_mw = NULL,
  ddep_a_ratio = NULL,
  ddep_d_ratio = NULL,
  ddep_hl_coeff = NULL,
  wdep_hl_coeff = NULL,
  wdep_in_cloud = NULL,
  wdep_below_cloud = NULL,
  rad_decay = NULL,
  resuspension = NULL) {
  if (is.null(name)) {
    if (is.null(model$species)) {
      name <- "species_1"
    } else {
      name <- paste0("species_",
        nrow(model$species) + 1)
    }
  }

  if (is.null(pdiam)) {
    pdiam <- 15.0
  }

  if (is.null(density)) {
    density <- 1.0
  }

  if (is.null(shape_factor)) {
    shape_factor <- 1.0
  }

  if (is.null(ddep_vel)) {
    ddep_vel <- 0.0
  }

  if (is.null(ddep_mw)) {
    ddep_mw <- 0.0
  }

  if (is.null(ddep_a_ratio)) {
    ddep_a_ratio <- 0.0
  }

  if (is.null(ddep_d_ratio)) {
    ddep_d_ratio <- 0.0
  }

  if (is.null(ddep_hl_coeff)) {
    ddep_hl_coeff <- 0.0
  }

  if (is.null(wdep_hl_coeff)) {
    wdep_hl_coeff <- 0.0
  }

  if (is.null(wdep_in_cloud)) {
    wdep_in_cloud <- 0.0
  }

  if (is.null(wdep_below_cloud)) {
    wdep_below_cloud <- 0.0
  }

  if (is.null(rad_decay)) {
    rad_decay <- 0.0
  }

  if (is.null(resuspension)) {
    resuspension <- 0.0
  }

  # Write species parameters to a data frame
  species <-
    data.frame(
      name = name,
      pdiam = pdiam,
      density = density,
      shape_factor = shape_factor,
      ddep_vel = ddep_vel,
      ddep_mw = ddep_mw,
      ddep_a_ratio = ddep_a_ratio,
      ddep_d_ratio = ddep_d_ratio,
      ddep_hl_coeff = ddep_hl_coeff,
      wdep_hl_coeff = wdep_hl_coeff,
      wdep_in_cloud = wdep_in_cloud,
      wdep_below_cloud = wdep_below_cloud,
      rad_decay = rad_decay,
      resuspension = resuspension,
      stringsAsFactors = FALSE
    )

  # Write data frame to the `species` list
  # component of `model`
  if (is.null(model$species)) {
    model$species <- species
  } else {
    model$species <-
      rbind(model$species, species)
  }

  return(model)
}


#########################################################
################# add_emissions
#' @export add_emissions
add_emissions <- function(model,
  rate = NULL,
  duration = NULL,
  start_day = NULL,
  start_hour = NULL,
  name = NULL) {
  if (is.null(name)) {
    if (is.null(model$emissions)) {
      name <- "emissions_1"
    } else {
      name <- paste0("emissions_",
        nrow(model$emissions) + 1)
    }
  }

  if (is.null(rate)) {
    rate <- 1
  }

  if (is.null(duration)) {
    duration <- 1
  }

  if (is.null(start_day)) {
    start_day <- "10-05-01"
  }

  if (is.null(start_hour)) {
    start_hour <- 0
  }


  # Write emissions parameters to a data frame
  emissions <-
    data.frame(
      name = name,
      rate = rate,
      duration = duration,
      start_day = start_day,
      start_hour = start_hour,
      stringsAsFactors = FALSE
    )

  # Write data frame to the `emissions` list
  # component of `model`
  if (is.null(model$emissions)) {
    model$emissions <- emissions
  } else {
    model$emissions <-
      rbind(model$emissions, emissions)
  }

  return(model)
}


#########################################################
################# add_grid
#' @export add_grid
add_grid <- function(model,
  lat = NULL,
  lon = NULL,
  range = c(5, 5),
  division = c(0.5, 0.5),
  start_day = NULL,
  start_hour = NULL,
  end_day = NULL,
  end_hour = NULL,
  duration = NULL,
  heights = NULL,
  samp_type = "avg",
  samp_interval = 24,
  name = NULL) {
  if (inherits(model, "traj_model")) {
    # Obtain the grid of lat/lon points
    grid <-
      create_grid(
        lat = lat,
        lon = lon,
        range = range,
        division = division
      )

    # Add the grid points to the model object
    model$lat <- grid$lat
    model$lon <- grid$lon

    return(model)
  }

  if (inherits(model, "disp_model")) {
    if (is.null(name)) {
      if (is.null(model$grids)) {
        name <- "grid_1"
      } else {
        name <- paste0("grid_",
          nrow(model$grids) + 1)
      }
    }

    if (is.null(lat)) {
      if (is.null(model$lat)) {
        lat <- NA
      } else {
        lat <- model$lat
      }
    }

    if (is.null(lon)) {
      if (is.null(model$lon)) {
        lon <- NA
      } else {
        lon <- model$lon
      }
    }

    if (is.null(heights)) {
      heights <- 50
      layers <- 1
    } else {
      layers <- length(heights)
      heights <-
        paste(heights, collapse = " ")
    }

    if (is.null(start_day)) {
      if (!is.null(model$start_day)) {
        start_day <- model$start_day
      } else {
        start_day <- NA
      }
    }

    if (is.null(start_hour)) {
      if (!is.null(model$start_hour)) {
        start_hour <- model$start_hour
      } else {
        start_hour <- NA
      }
    }

    if (is.null(end_day) &
        is.null(end_hour)) {
      duration <- NA
      end_day <- NA
      end_hour <- NA
    }

    # Write grid parameters to a data frame
    grid <-
      data.frame(
        name = name,
        lat = lat,
        lon = lon,
        range_lat = range[1],
        range_lon = range[2],
        division_lat = division[1],
        division_lon = division[2],
        duration = duration,
        start_day = start_day,
        start_hour = start_hour,
        end_day = end_day,
        end_hour = end_hour,
        heights = heights,
        samp_type = samp_type,
        samp_interval = samp_interval,
        stringsAsFactors = FALSE
      )

    # Write data frame to the `grids` list
    # component of `model`
    if (is.null(model$grids)) {
      model$grids <- grid
    } else {
      model$grids <-
        rbind(model$grids, grid)
    }

    return(model)
  }
}


#########################################################
################# subset_nc_date
#' @export subset_nc_date
subset_nc_date <- function(hpbl_file = NULL,
  hpbl_brick = NULL,
  varname = NULL,
  vardate) {
  if ((is.null(hpbl_file)  & is.null(hpbl_brick)) |
      (!is.null(hpbl_file) & !is.null(hpbl_brick)))
    stop("Uh oh! Please define EITHER hpbl_file OR hpbl_brick")

  Sys.setenv(TZ = 'UTC')

  if (!is.null(hpbl_file))
    rasterin <- rotate(brick(hpbl_file, varname = varname))
  if (!is.null(hpbl_brick))
    rasterin <- hpbl_brick

  #get time vector to select layers
  dates <- names(rasterin)
  dates <- gsub('X', '', dates)
  dates <- gsub('\\.', '-', dates)

  # Get first day of the month for vardate
  vardate_month <- as.Date(paste(year(vardate),
    month(vardate),
    '01',
    sep = '-'))

  #select layer
  layer <- which(dates == vardate_month)
  if (length(layer) == 0)
    stop(
      "Cannot match the dates of PBL raster file. Did you set the time zone to UTC before reading it in? (Sys.setenv(TZ='UTC'))"
    )

  rastersub <- raster::subset(rasterin, subset = layer)

  return(rastersub)
}

