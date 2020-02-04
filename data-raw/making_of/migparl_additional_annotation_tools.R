migparl_add_s_attribute_speech <- function(corpus, mc = 4L, progress = TRUE, package){
  speeches <- as.speeches(
    corpus, gap = 500, mc = mc, progress = progress,
    s_attribute_date = "date", s_attribute_name = "speaker"
  )
  
  regions_list <- lapply(
    speeches@objects,
    function(x){
      dt <- data.table::data.table(x@cpos)
      dt[["speech"]] <- x@name
      dt
    }
  )
  
  dt <- data.table::rbindlist(regions_list)
  setnames(dt, old = c("V1", "V2"), new = c("cpos_left", "cpos_right"))
  dt[, "cpos_left" := as.integer(dt[["cpos_left"]]) ]
  dt[, "cpos_right" := as.integer(dt[["cpos_right"]]) ]
  setorderv(dt, cols = "cpos_left", order = 1L)
  corpus_charset <- cwbtools::registry_file_parse(corpus = corpus)[["properties"]][["charset"]]
  data_dir <- cwbtools::registry_file_parse(corpus = corpus)[["home"]]
  
  cwbtools::s_attribute_encode(
    values = dt[["speech"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = data_dir,
    s_attribute = "speech",
    corpus = corpus,
    region_matrix = as.matrix(dt[, c("cpos_left", "cpos_right")]),
    registry_dir = set_regdir(package = package),
    encoding = corpus_charset,
    method = "R",
    verbose = TRUE, 
    delete = FALSE
    )
  
  invisible(dt)
}

migparl_encode_lda_topics <- function(corpus = corpus, model, k = 250, n = 5, package){
  
  data_dir <- cwbtools::registry_file_parse(corpus = corpus, registry_dir = set_regdir(package))[["home"]]
  corpus_charset <- cwbtools::registry_file_parse(corpus = corpus)[["properties"]][["charset"]]

  message("... getting topic matrix")
  topic_matrix <- topicmodels::topics(model, k = n)
  topic_dt <- data.table::data.table(
    speech = colnames(topic_matrix),
    topics = apply(topic_matrix, 2, function(x) sprintf("|%s|", paste(x, collapse = "|"))),
    key = "speech"
  )
  
  message("... decoding s-attribute speech")
  if (!"speech" %in% s_attributes(corpus)){
    stop("The s-attributes 'speech' is not yet present.",
         "Use the function add_s_attribute_speech to generate it.")
  }
  cpos_dt <- data.table::as.data.table(RcppCWB::s_attribute_decode(corpus, s_attribute = "speech", method = "R", data_dir = data_dir))
  names(cpos_dt) <- c("cpos_left", "cpos_right", "speech")
  setkeyv(cpos_dt, "speech")
  
  
  ## Merge tables
  cpos_dt2 <- topic_dt[cpos_dt]
  setorderv(cpos_dt2, cols = "cpos_left", order = 1L)
  cpos_dt2[["speech"]] <- NULL
  cpos_dt2[["id"]] <- NULL
  cpos_dt2[, topics := ifelse(is.na(topics), "||", topics)]
  setcolorder(cpos_dt2, c("cpos_left", "cpos_right", "topics"))
  
  # some sanity tests
  message("... running some sanity checks")
  coverage <- sum(cpos_dt2[["cpos_right"]] - cpos_dt2[["cpos_left"]]) + nrow(cpos_dt2)
  if (coverage != size(corpus)) stop("sizes don't match") 
  P <- partition(corpus, speech = ".*", regex = TRUE)
  if (sum(cpos_dt2[["cpos_left"]] - P@cpos[,1]) != 0) stop()
  if (sum(cpos_dt2[["cpos_right"]] - P@cpos[,2]) != 0) stop()
  if (length(sAttributes(corpus, "speech", unique = FALSE)) != nrow(cpos_dt2)) stop()
  
  message("... encoding s-attribute 'topics'")
  cwbtools::s_attribute_encode(
    values = cpos_dt2[["topics"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = data_dir,
    s_attribute = "topics",
    corpus = corpus,
    region_matrix = as.matrix(cpos_dt2[, c("cpos_left", "cpos_right")]),
    registry_dir = set_regdir(package),
    encoding = corpus_charset,
    method = "R",
    verbose = TRUE, 
    delete = FALSE
  )
}

migparl_encode_mig_prob <- function(corpus = corpus, model, package = package_to_use, topic_numbers = topic_numbers){
  
  data_dir <- cwbtools::registry_file_parse(corpus = corpus, registry_dir = set_regdir(package))[["home"]]
  corpus_charset <- cwbtools::registry_file_parse(corpus = corpus)[["properties"]][["charset"]]
  
  message("... getting topic matrix")
  topic_matrix <- topicmodels::posterior(model)$topics
  topic_matrix_subset <- topic_matrix[,topic_numbers]
  prob_of_relevance <- rowSums(topic_matrix_subset)
  
  migration_integration_probability_dt <- data.table::data.table(
    speech = names(prob_of_relevance), 
    migration_integration_probability = as.numeric(prob_of_relevance), 
    key = "speech")
  
  message("... decoding s-attribute speech")
  if (!"speech" %in% s_attributes(corpus)){
    stop("The s-attributes 'speech' is not yet present.",
         "Use the function add_s_attribute_speech to generate it.")
  }
  cpos_dt <- data.table::as.data.table(RcppCWB::s_attribute_decode(corpus, s_attribute = "speech", method = "R", data_dir = data_dir, encoding = corpus_charset))
  names(cpos_dt) <- c("cpos_left", "cpos_right", "speech")
  data.table::setkeyv(cpos_dt, "speech")
  ## Merge tables
  cpos_dt2 <- migration_integration_probability_dt[cpos_dt]
  data.table::setorderv(cpos_dt2, cols = "cpos_left", order = 1L)
  cpos_dt2[["speech"]] <- NULL
  cpos_dt2[["id"]] <- NULL
  cpos_dt2[, migration_integration_probability := ifelse(is.na(migration_integration_probability), "0", migration_integration_probability)]
  data.table::setcolorder(cpos_dt2, c("cpos_left", "cpos_right", "migration_integration_probability"))
  
  # some sanity tests
  message("... running some sanity checks")
  coverage <- sum(cpos_dt2[["cpos_right"]] - cpos_dt2[["cpos_left"]]) + nrow(cpos_dt2)
  if (coverage != size(corpus)) stop("sizes don't fit!")
  P <- partition(corpus, speech = ".*", regex = TRUE)
  if (sum(cpos_dt2[["cpos_left"]] - P@cpos[,1]) != 0) stop()
  if (sum(cpos_dt2[["cpos_right"]] - P@cpos[,2]) != 0) stop()
  if (length(s_attributes(corpus, "speech", unique = FALSE)) != nrow(cpos_dt2)) stop()
  
  message("... encoding s-attribute 'topics'")
  cwbtools::s_attribute_encode(
    values = as.character(cpos_dt2[["migration_integration_probability"]]), # is still UTF-8, recoding done by s_attribute_encode
    data_dir = data_dir,
    s_attribute = "migration_integration_probability",
    corpus = corpus,
    region_matrix = as.matrix(cpos_dt2[, c("cpos_left", "cpos_right")]),
    registry_dir = set_regdir(package),
    encoding = corpus_charset,
    method = "R",
    verbose = TRUE, 
    delete = FALSE
  )
}


set_regdir <- function(package){
  system.file(package = package, "extdata", "cwb", "registry")
}


topic_regexR <- function(topics = mig_int_topics, topic_pattern = "^.*\\|X\\|.*$") {
  S2 <- strsplit(topics, "|", fixed = TRUE)[[1]]
  topic_regex <- as.character()
  for (topic in S2) topic_regex <- paste0(topic_regex,  gsub("X", topic, topic_pattern), sep = "|")
  topic_regex <- substr(topic_regex, 1, nchar(topic_regex)-1)
  topic_regex <- sprintf("(%s)", topic_regex)
  
  return(topic_regex)
}


migparl_reencode_lda_topics <- function(corpus = corpus, model, k = 250, n = 5, package, new_attribute = new_attribute){
  
  data_dir <- cwbtools::registry_file_parse(corpus = corpus, registry_dir = set_regdir(package))[["home"]]
  corpus_charset <- cwbtools::registry_file_parse(corpus = corpus)[["properties"]][["charset"]]
  
  model <- model
  
  message("... getting topic matrix")
  topic_matrix <- topicmodels::topics(model, k = n)
  topic_dt <- data.table::data.table(
    speech = colnames(topic_matrix),
    topics = apply(topic_matrix, 2, function(x) sprintf("|%s|", paste(x, collapse = "|"))),
    key = "speech"
  )
  
  message("... decoding s-attribute speech")
  if (!"speech" %in% s_attributes(corpus)){
    stop("The s-attributes 'speech' is not yet present.",
         "Use the function add_s_attribute_speech to generate it.")
  }
  cpos_dt <- decode(corpus, s_attribute = "speech")
  setkeyv(cpos_dt, "speech")
  
  
  ## Merge tables
  cpos_dt2 <- topic_dt[cpos_dt]
  setorderv(cpos_dt2, cols = "cpos_left", order = 1L)
  cpos_dt2[["speech"]] <- NULL
  cpos_dt2[["id"]] <- NULL
  cpos_dt2[, topics := ifelse(is.na(topics), "||", topics)]
  setcolorder(cpos_dt2, c("cpos_left", "cpos_right", "topics"))
  
  # some sanity tests
  message("... running some sanity checks")
  coverage <- sum(cpos_dt2[["cpos_right"]] - cpos_dt2[["cpos_left"]]) + nrow(cpos_dt2)
  if (coverage != size(corpus)) stop()
  P <- partition(corpus, speech = ".*", regex = TRUE)
  if (sum(cpos_dt2[["cpos_left"]] - P@cpos[,1]) != 0) stop()
  if (sum(cpos_dt2[["cpos_right"]] - P@cpos[,2]) != 0) stop()
  if (length(sAttributes(corpus, "speech", unique = FALSE)) != nrow(cpos_dt2)) stop()
  
  message("... encoding s-attribute 'topics'")
  cwbtools::s_attribute_encode(
    values = cpos_dt2[["topics"]], # is still UTF-8, recoding done by s_attribute_encode
    data_dir = data_dir,
    s_attribute = new_attribute,
    corpus = corpus,
    region_matrix = as.matrix(cpos_dt2[, c("cpos_left", "cpos_right")]),
    registry_dir = set_regdir(package),
    encoding = corpus_charset,
    method = "R",
    verbose = TRUE, 
    delete = TRUE
  )
}
