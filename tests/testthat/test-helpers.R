#------------------------------------------------------------------------------*
# Test API key access
#------------------------------------------------------------------------------*

test_that("error if no API key", {
  if(Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")==""){
    expect_error(get_gt_api_key())
  } else {
    Sys.setenv(GOOGLE_TRENDS_FOR_HEALTH_API_KEY = "")
    expect_error(get_gt_api_key())
  }
})

test_that("reads saved API key", {
  if(Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")!=""){
    expect_type(get_gt_api_key(), "character")
  }
})

test_that("returns provided key", {
  expect_equal("aaa", get_gt_api_key(key = "aaa"))
})

test_that("sets a temporary key", {
  suppressMessages(set_gt_api_key(key = "aaa"))
  expect_equal("aaa", get_gt_api_key())
})




#------------------------------------------------------------------------------*
# Test API key setting
#------------------------------------------------------------------------------*

old_key <- Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")
temp_dir <- tempdir()

test_that("error if path not available", {
  expect_error(
    set_gt_api_key("aaa", path = "!"),
    regexp = "not available"
  )
  suppressMessages(set_gt_api_key(old_key))
})

test_that("set the API key in the environment variables", {
  suppressMessages(set_gt_api_key("aaa"))
  expect_equal(
    get_gt_api_key(),
    expected = "aaa"
  )
  suppressMessages(set_gt_api_key(old_key))
})

test_that("install the API key to .Renviron (in a temp_dir)", {
  expect_equal(
    suppressMessages(set_gt_api_key("aaa", install = TRUE, path = temp_dir)),
    "aaa"
  )
  remove_gt_api_key(remove = TRUE, path = temp_dir)

  suppressMessages(set_gt_api_key(old_key))
})

test_that("error if key exists and not overwritting", {
  suppressMessages(set_gt_api_key("aaa", install = TRUE, path = temp_dir))
  expect_error(
    suppressMessages(
      set_gt_api_key("aaa", install = TRUE, path = temp_dir)
    ),
    regexp = "already exists"
  )
  remove_gt_api_key(remove = TRUE, path = temp_dir)

  suppressMessages(set_gt_api_key(old_key))
})

test_that("overwrite the API key to .Renviron (in a temp_dir)", {
  suppressMessages(set_gt_api_key("aaa", install = TRUE, path = temp_dir))
  expect_equal(
    suppressMessages(
      set_gt_api_key("aaa", install = TRUE, overwrite = TRUE, path = temp_dir)
    ),
    "aaa"
  )
  remove_gt_api_key(remove = TRUE, path = temp_dir)

  suppressMessages(set_gt_api_key(old_key))
})


# clean up
suppressMessages(set_gt_api_key(old_key))
unlink(
  list.files(tempdir(), all.files = TRUE, full.names = TRUE, pattern = ".Renv")
)
