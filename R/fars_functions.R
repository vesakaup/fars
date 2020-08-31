# fars_functions.R
# fars functions with documentation
# August 27, 2020
# Vesa Kauppinen

#' Read fars data file
#'
#' @param filename the name of the data file (as string)
#' @return data frame named data
#' @return if the filename input is not found, returns an error message "file *filename* does not exist"
#' @examples \dontrun{ fars_read("accident_2013.csv.bz2") }
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df


fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Make filename
#'
#' @param year is an integer representing year
#' @return string representing a filename
#' @examples \dontrun{ make_filename(2013) }


make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Read individual files (each year)
#'
#' @param years is an integer or list or vector representing year(s)
#' @return data frames for each year-file containing month and year columns
#' @return if year is invalid (no existing file) returns warning
#'
#' @examples \dontrun{
#'  fars_read_years (2013)
#'  fars_read_years (2013:2015)
#'  fars_read_years (c(2013,2015))
#' }
#' @importFrom dplyr mutate
#' @importFrom dplyr select


fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>% 
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#'Summarize year file
#'
#' @param years is an integer or list or vector representing year(s)
#' @return data frame containing a row for each month and columns with counts for each year
#' @examples \dontrun{
#' fars_summarize_years(2013)
#' fars_summarize_years(2013:2015)
#' fars_summarize_years(c(2013,2015))
#' }
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom tidyr spread

fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>% 
                dplyr::group_by(year, MONTH) %>% 
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Create a state map
#'
#' @param state.num State number code
#' @param year Year of data file
#' @examples \dontrun{
#' fars_map_state(1,2013)
#' fars_map_state(4,2015)
#' }
#' @return plot of map
#' @return if state number or file corresponding to year does not exist
#' @importFrom graphics points
#' @importFrom maps map


fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
