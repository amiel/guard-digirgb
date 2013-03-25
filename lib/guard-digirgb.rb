require "guard-digirgb/version"
require 'digiusb/digiblink'

module Guard::Notifier::Digirgb
  extend self

  DEFAULTS = {
    :success                => 'green',
    :failed                 => 'red',
    :pending                => '#ff5500',
    :default                => 'black',
  }

  def available?(silent = false)
    true
  end

  def notify(type, title, message, image, options = { })
    color = _color(type, options)

    set_color(color)
  end

  def _color(type, options = { })
    case type
    when 'success'
      options[:success] || DEFAULTS[:success]
    when 'failed'
      options[:failed]  || DEFAULTS[:failed]
    when 'pending'
      options[:pending] || DEFAULTS[:pending]
    else
      options[:default] || DEFAULTS[:default]
    end
  end

  def turn_on(options = {})
    puts "TURNING DigiBlink notification on"
  end

  def get_spark
    @light ||= DigiBlink.sparks.last
  end

  def set_color(color)
    get_spark.color = color
  rescue LIBUSB::ERROR_NO_DEVICE
    @light = nil
  end
end

::Guard::Notifier::NOTIFIERS << [[:digirgb, ::Guard::Notifier::Digirgb]]


module Guard::Notifier
  def notify(*)
    # This never gets called
    raise "NOTIFY"
  end
end
