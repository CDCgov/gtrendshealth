#' Set up a GOOGLE TRENDS FOR HEALTH API Key for Repeated Use
#'
#' @description This function will set your GOOGLE TRENDS FOR HEALTH API key
#' as an environment variable.
#' If using \code{install =  TRUE} then the key will also be saved to your
#'  \code{.Renviron} file so it can be called securely without being stored
#' in your code. After you have installed your key, it can be called any time by
#' typing \code{Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")} and can be
#' used in package functions by simply typing GOOGLE_TRENDS_FOR_HEALTH_API_KEY
#' If you do not have an \code{.Renviron} file, the function will create one
#' for you. If you already have an \code{.Renviron} file, the function will
#' append the key to your existing file, while making a backup of your
#' original file for recovery purposes.
#'
#' @param key The API key from your Google Developer project authorized for
#' Google Trends for Health API use, formatted in quotes.
#' A key can be acquired by requesting access at
#' \url{https://support.google.com/trends/contact/trends_api} and following the
#' setup instructions.
#' @param install if TRUE, will install the key in your \code{.Renviron} file
#' for use in future sessions. Defaults to FALSE.
#' @param overwrite If this is set to TRUE, it will overwrite an existing
#' CENSUS_API_KEY that you already have in your \code{.Renviron} file.
#' @param path Path to install the API key into.
#'
#' @examples
#'
#' \donttest{
#' set_gt_api_key("111111abc", install = TRUE, path = tempdir())
#' # The first time, reload your environment so you can use the key without
#' # restarting R.
#' readRenviron("~/.Renviron")
#' # You can check it with:
#' Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")
#'
#' # If you need to overwrite an existing key:
#' set_gt_api_key(
#'   "111111abc", overwrite = TRUE, install = TRUE, path = tempdir()
#' )
#' # The first time, reload your environment so you can use the key without
#' # restarting R.
#' readRenviron("~/.Renviron")
#' # You can check it with:
#' Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")
#'
#' # clean up
#' unlink(
#' list.files(tempdir(), all.files = TRUE, full.names = TRUE, pattern = ".Renv")
#' )
#' }
#' @export

set_gt_api_key <- function(
    key, overwrite = FALSE, install = FALSE, path = "HOME"
){
  # verify path
  path <- gt_verify_path(path)

  if (install) {

    renv <- file.path(path, ".Renviron")

    # Backup original .Renviron before doing anything else here.
    if(file.exists(renv)){
      file.copy(renv, file.path(path, ".Renviron_backup"))
    }

    if(!file.exists(renv)){
      file.create(renv)
    } else {
      oldenv <- readLines(renv)
      if(isTRUE(overwrite)){
        message(
          paste(
            "Your original .Renviron was backed up and stored in your",
            "HOME directory in case you need to restore it."
          )
        )
        remove_gt_api_key(remove = TRUE, path = path)
      } else {
        if(any(grepl("GOOGLE_TRENDS_FOR_HEALTH_API_KEY", oldenv))){
          stop(
            paste(
              "A GOOGLE_TRENDS_FOR_HEALTH_API_KEY already exists.",
              "You can overwrite it with the argument overwrite=TRUE"
            ),
            call.=FALSE
          )
        }
      }
    }

    keyconcat <- paste0("GOOGLE_TRENDS_FOR_HEALTH_API_KEY='", key, "'")
    # Append API key to .Renviron file
    write(keyconcat, renv, sep = "\n", append = TRUE)
    message(
      paste(
        'Your API key has been stored in your .Renviron and can be accessed by',
        'Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY").',
        '\nTo use now, restart R or run `readRenviron("~/.Renviron")`'
      )
    )
  } else {
    message(
      paste(
        "To install your API key for use in future sessions, run this function",
        "with `install = TRUE`."
      )
    )
  }

  Sys.setenv(GOOGLE_TRENDS_FOR_HEALTH_API_KEY = key)
  return(key)
}




#' Verify provided path
#' @description Verify path availability.
#' @param path Path to verify.
#' @keywords internal
gt_verify_path <- function(path){
  if(path == "HOME") path <- Sys.getenv("HOME")
  if(!file.exists(path)) stop("Path ", path, " not available!")
  if(file.access(path, mode = 2) != 0) stop("Path ", path, " not writeable!")
  return(path)
}




#' Delete a saved GOOGLE TRENDS FOR HEALTH API Key
#' @description This function will uninstall your GOOGLE TRENDS FOR HEALTH API
#' key from the environment variables. If a path is provided, it will
#' be used to remove the key from .Renviron file in that path.
#' @param remove Whether to remove the key.
#' @param path Path to look for an .Renviron file.
#' @keywords internal
remove_gt_api_key <- function(
    remove = FALSE,
    path = NULL
){
  if(remove){
    Sys.unsetenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")

    if(!is.null(path)){
      # verify path
      path <- gt_verify_path(path)

      renv <- file.path(path, ".Renviron")

      if(file.exists(renv)){
        # Backup original .Renviron before doing anything else here.
        file.copy(renv, file.path(path, ".Renviron_backup"))

        oldenv <- readLines(renv)

        newenv <- grep(
          "GOOGLE_TRENDS_FOR_HEALTH_API_KEY",
          oldenv, value = TRUE, invert = TRUE
        )
        writeLines(newenv, renv, sep = "\n")
      }
    }
  }
}



#' Read the GOOGLE TRENDS FOR HEALTH API Key
#' @description This function will read your GOOGLE TRENDS FOR HEALTH API key
#' from the environment variables.
#' If you do not have an \code{.Renviron} file, the function will create one
#' for you. If you already have an \code{.Renviron} file, the function will
#' append the key to your existing file, while making a backup of your
#' original file for recovery purposes.
#' @param key The API key from your Google Developer project authorized for
#' Google Trends for Health API use, formatted in quotes.
#' A key can be acquired by requesting access at
#' \url{https://support.google.com/trends/contact/trends_api} and following the
#' setup instructions.
#'

#' @examples
#'
#' \dontrun{
#' get_gt_api_key()
#' }
#'
#' @export

# Check to see if a Google Trends API key is installed
get_gt_api_key <- function(key = NULL) {

  # If a key is supplied, return it
  if (!is.null(key)) {
    return(key)

  } else if (Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY") == "") {
    stop(
      paste(
        "You have not set a Google Trends API key.",
        "Your API key Google User should also be authorized for",
        "Google Trends for Health use."

      ),
      paste(
        "You can get an API key by requesting access at",
        "https://support.google.com/trends/contact/trends_api",
        "and then supply the key to the `gt_api_key()` function to use it",
        "throughout the session."

      ),
      .call = FALSE
    )

    return(NULL)

  } else {

    return(Sys.getenv('GOOGLE_TRENDS_FOR_HEALTH_API_KEY'))

  }
}
