#' @export
#' @importFrom R.utils getAbsolutePath
#' @importFrom utils compareVersion packageVersion
#' @import zip
#' @title compress a folder
#' @description compress a folder to a target file. The
#' function returns the complete path to target file.
#' @details
#' The function is using \link[utils]{zip}, it needs a zip program.
#' @param folder folder to compress
#' @param target path of the archive to create
pack_folder <- function( folder, target ){

  target <- getAbsolutePath(path.expand(target))
  folder <- getAbsolutePath(path.expand(folder))
  if( compareVersion(as.character(packageVersion("zip")), "1.0.0") > 0 ){
    ## replacement when zip will be greater than 1.0.0
    # zip::zipr(zipfile = target,
    #           files = list.files(path = folder, all.files = FALSE, full.names = TRUE),
    #           recurse = TRUE)
    call_ <- call("zipr", zipfile = target,
                  files = list.files(path = folder, all.files = FALSE, full.names = TRUE),
                  recurse = TRUE)
    eval(call_)
    return(target)
  }

  curr_wd <- getwd()
  setwd(folder)

  tryCatch(
    zip::zip(zipfile = target,
        files = list.files(all.files = TRUE, recursive = TRUE))
    , error = function(e) {
      stop("Could not write ", shQuote(target), " [", e$message, "]")
    }
    , finally = {
      setwd(curr_wd)
    })

  target
}

#' @export
#' @importFrom utils unzip
#' @importFrom R.utils getAbsolutePath
#' @title Extract files from a zip file
#' @description Extract files from a zip file to a folder. The
#' function returns the complete path to destination folder.
#' @details
#' The function is using \link[utils]{unzip}, it needs an unzip program.
#' @param file path of the archive to unzip
#' @param folder folder to create
unpack_folder <- function( file, folder ){

  file <- getAbsolutePath(path.expand(file))
  folder <- getAbsolutePath(path.expand(folder))
  stopifnot(file.exists(file))

  unlink(folder, recursive = TRUE, force = TRUE)

  unzip( zipfile = file, exdir = folder )

  folder
}
