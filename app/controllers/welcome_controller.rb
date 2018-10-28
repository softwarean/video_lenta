class WelcomeController < ApplicationController
  def index
    gon.push({
               base_path: configus.player.path
             })
  end

  def about
    @meta_title = t('about_title')
    @title = t('about_title')
  end
end
