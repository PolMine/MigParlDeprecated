#' Download corpora from Web Directory.
#' 
#' \code{migparl_download_corpus} will get a tarball with the indexed corpus
#' from a directory (web dir) and install the corpus into the MigParl package.
#' @param corpus tarball Name of the corpus to install.
#' @param webdir (web) directory where the tarball resides
#' @param user user info in case of password protected corpus
#' @param password password info in case of password protected corpus
#' @param archive logical; whether an older version of the corpus from the archive should be installed instead.
#' @param version if archive == TRUE, a corpus version must be specified.
#' @export migparl_download_corpus
#' @rdname install_migparl
#' @importFrom cwbtools corpus_install
#' @importFrom RCurl url.exists
#' @importFrom rstudioapi showPrompt askForPassword
#'@examples
#'\dontrun{
#'migparl_download_corpus(corpus = "MIGPARL", archive = TRUE, version = "2018-11-27")
#'}

migparl_download_corpus <- function(corpus = "MigParl", webdir = "https://polmine.sowi.uni-due.de/corpora/cwb/migparl", user = NULL, password = NULL, archive = FALSE, version = NULL) {
  
  if (archive == TRUE && is.null(version)) stop("... if archive is TRUE, then corpus version must be specified!")
  
  # if working from within RStudio, use RStudio prompts, otherwise use console prompts
  if (Sys.getenv("RSTUDIO") == 1) {
    if (length(corpus) == 1L){
      if (archive == FALSE) {
        tarball <- file.path(webdir, sprintf("%s.tar.gz", tolower(corpus)))
      } else {
        webdir = "https://polmine.sowi.uni-due.de/corpora/cwb/migparl/archive"
        tarball <- file.path(webdir, sprintf("%s_%s.tar.gz", tolower(corpus), version))
      }
      if (is.null(user)){
        user <- rstudioapi::showPrompt(title = "User ID", message = "Please enter your user name.", default = "")
      }
      if (is.null(password)){
        password <- rstudioapi::askForPassword(prompt = "Please enter password.")
      }
      
      message("... downloading tarball: ", tarball)
      cwbtools::corpus_install(pkg = "MigParl", tarball = tarball, user = user, password = password)
      
    } else {
      if (missing(corpus)) corpus <- "MigParl"
      if (is.null(user)){
        user <- rstudioapi::showPrompt(title = "User ID", message = "Please enter your user name.", default = "")
      }
      if (is.null(password)){
        password <- rstudioapi::askForPassword(prompt = "Please enter password.")
      }
      for (x in corpus) migparl_download_corpus(corpus = x, webdir = webdir, user = user, password = password)
    }
    
  } else {
    
    if (length(corpus) == 1L){
      tarball <- file.path(webdir, sprintf("%s.tar.gz", tolower(corpus)))
      if (is.null(user)){
        user <- readline(prompt = "Please enter your user name: ")
      }
      if (is.null(password)){
        password <- readline(prompt = "Please enter password: ")
      }
      
      message("... downloading tarball: ", tarball)
      cwbtools::corpus_install(pkg = "MigParl", tarball = tarball, user = user, password = password)
      
    } else {
      if (missing(corpus)) corpus <- "MigParl"
      if (is.null(user)){
        user <- readline(prompt = "Please enter your user name: ")
      }
      if (is.null(password)){
        password <- readline(prompt = "Please enter password: ")
      }
      for (x in corpus) migparl_download_corpus(corpus = x, webdir = webdir, user = user, password = password)
    }
  }
}
