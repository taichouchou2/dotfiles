" controller
syn keyword rubyRailsMethod params request response session headers cookies flash
syn keyword rubyRailsRenderMethod render
syn keyword rubyRailsMethod logger polymorphic_path polymorphic_url
syn keyword rubyRailsControllerMethod helper helper_attr helper_method filter layout url_for serialize exempt_from_layout filter_parameter_logging hide_action cache_sweeper protect_from_forgery caches_page cache_page caches_action expire_page expire_action rescue_from
syn keyword rubyRailsRenderMethod head redirect_to render_to_string respond_with
syn match   rubyRailsRenderMethod '\<respond_to\>?\@!'
syn keyword rubyRailsFilterMethod before_filter append_before_filter prepend_before_filter after_filter append_after_filter prepend_after_filter around_filter append_around_filter prepend_around_filter skip_before_filter skip_after_filter skip_filter
syn keyword rubyRailsFilterMethod verify

