require "viewaide"

ActionView::Base.send :include, Viewaide::Helpers
ActionController::Base.send :include, Viewaide::PartialCaching
