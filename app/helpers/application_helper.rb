module ApplicationHelper
  include ActionView::Helpers::JavaScriptHelper


  # -------------------------------------------------------------
  # For using nested layouts
  def inside_layout(layout = 'wrapper', &block)
    render :inline => capture_haml(&block), :layout => "layouts/#{layout}"
  end


  # -------------------------------------------------------------
  def controller_stylesheet_link_tag
    c = params[:controller] || controller_name
    stylesheet_link_tag c if Rails.application.assets.find_asset("#{c}.css")
  end


  # -------------------------------------------------------------
  def controller_javascript_include_tag
    c = params[:controller] || controller_name
    javascript_include_tag c if Rails.application.assets.find_asset("#{c}.js")
  end


  # -------------------------------------------------------------
  def make_html(unescaped)
    return CGI::unescapeHTML(unescaped.to_s).html_safe
  end


  # -------------------------------------------------------------
  TEASER_LENGTH = 140
  def teaser(text, length = TEASER_LENGTH)
    plain = ActionController::Base.helpers.strip_tags(make_html(text))
    if (plain.size < length)
      return plain
    else
      shorten = plain[0..length]
      space = shorten.rindex(/\s/)
      if space.nil?
        shorten = shorten.to_s + "..."
      else
        shorten = shorten[0..space].to_s + "..."
      end
      return shorten
    end
  end


  # -------------------------------------------------------------
  # Returns the correct twitter bootstrap class mapping for different
  # types of flash messages
  #
  FLASH_CLASS = {
      success:     'alert-success',
      'success' => 'alert-success',
      error:       'alert-danger',
      'error'   => 'alert-danger',
      alert:       'alert-warning',
      'alert'   => 'alert-warning',
      block:       'alert-warning',
      'block'   => 'alert-warning',
      warning:     'alert-warning',
      'warning' => 'alert-warning',
      notice:      'alert-info',
      'notice'  => 'alert-info',
      info:        'alert-info',
      'info'    => 'alert-info'
  }
  def flash_class_for(level)
    puts "level = #{level}, class = #{FLASH_CLASS[level]}"
    FLASH_CLASS[level] || level.to_s
  end


  # -------------------------------------------------------------
  # Returns a FontAwesome icon name (without the prefix), if there
  # is one associated with the tag provided
  #
  ICON_NAME = {
      'success' => 'ok-sign',
      'error'   => 'exclamation-sign',
      'danger'  => 'exclamation-sign',
      'alert'   => 'warning-sign',
      'block'   => 'warning-sign',
      'warning' => 'warning-sign',
      'notice'  => 'info-sign',
      'info'    => 'info-sign',

      'show'    => 'zoom-in',
      'edit'    => 'edit',
      'delete'  => 'trash',
      'destroy' => 'trash',
      'back'    => 'reply',
      'new'     => 'plus',
      'add'     => 'plus',
      'ok'      => 'ok-sign',
      'cancel'  => 'remove-sign',
      'yes'     => 'thumbs-up',
      'no'      => 'thumbs-down',
      'like'    => 'thumbs-up',
      'unlike'  => 'thumbs-down'
  }
  def icon_name_for(tag)
    if !tag.nil?
      tag = tag.to_s
      if !tag.start_with?('glyphicon-', 'fa-')
        tag = tag.downcase.sub(/[^a-zA-Z0-9_-].*$/, '')
        name = ICON_NAME[tag] || tag
        if name.nil?
          name
        else
          'glyphicon-' + name
        end
      else
        tag
      end
    else
      tag
    end
  end


  # -------------------------------------------------------------
  def icon_tag_for(name, options = {})
    cls = icon_name_for(name) + ' icon-fixed-width'
    if cls.nil?
      ''
    else
      if cls.start_with?('glyphicon-')
        cls = 'glyphicon ' + cls
      elsif cls.start_with?('fa-')
        cls = 'fa ' + cls
      end
      if options[:class]
        cls = options[:class] + ' ' + cls
      else
        options[:class] = cls
      end
      content_tag :i, nil, class: cls
    end
  end


  # -------------------------------------------------------------
  def icon2x_tag_for(name, options = {})
    if options[:class]
      options[:class] += ' icon-2x'
    else
      options[:class] = 'icon-2x'
    end
    icon_tag_for(name, options)
  end


  # -------------------------------------------------------------
  def icon4x_tag_for(name, options = {})
    if options[:class]
      options[:class] += ' icon-4x'
    else
      options[:class] = 'icon-4x'
    end
    icon_tag_for(name, options)
  end


  # -------------------------------------------------------------
  # Creates a link styled as aBootstrap button.
  #
  def button_link(label, destination = '#', options = {})
    options[:class] = options[:class] || 'btn'
    if options[:btn]
      options[:class] = options[:class] + ' btn-' + options[:btn]
      options.delete(:btn)
    end
    if options[:size]
      options[:class] = options[:class] + ' btn-' + options[:size]
      options.delete(:size)
    end
    if options[:color]
      options[:class] = options[:class] + ' btn-' + options[:color]
      options.delete(:color)
    else
      options[:class] = options[:class] + ' btn-default'
    end
    text = label
    if options[:icon]
      text = icon_tag_for(options[:icon]) + ' ' + text
    end
    link_to text, destination, options
  end


  # -------------------------------------------------------------
  # Creates a difficulty belt image.
  #
  BELT_COLOR = ['White', 'Yellow', 'Orange', 'Green', 'Blue', 'Violet',
    'Brown', 'Black']
  def difficulty_image(val)
    levels = 8
    increments = 100.0/8
    if val <= 0
      num = 1
    elsif val > 100
      num = 8
    else
      num = val / (increments).round
    end
    if num == 0
      color = 'White'
    else
      color = BELT_COLOR[num]
    end
    image_tag('belt' + num.to_s + '.png',
      alt: color.to_s + ' Belt (' + val.to_s + ')',
      class: 'difficulty')
  end


  # -------------------------------------------------------------
  def n_to_s(val)
    if val == val.to_i
      val.to_i.to_s
    else
      val.round(1).to_s
    end
  end

end
