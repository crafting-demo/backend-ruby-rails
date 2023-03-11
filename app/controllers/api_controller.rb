# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :set_message

  def api_call_handler
    received_at = Time.current
    Rails.logger.info("Received API message #{@message[:message]} at #{received_at}")

    response = {
      receivedTime: received_at,
    }

    case @message[:message]
    when 'Hello! How are you?'
      response[:message] = "Hello! This is Ruby Rails service."
    when 'Please echo'
      response[:message] = "Echo from Ruby Rails service. " + @message[:value]
    when 'Read from database'
      result = read_entity('mysql', @message[:key])
      if result.blank?
        Rails.logger.warn("Not found key " + @message[:key])
        response[:message] = "Ruby Rails service: failed to read from database"
      else
        response[:message] = "Ruby Rails service: successfully read from database, value: " + result
      end
    when 'Write to database'
      write_entity('mysql', @message[:key], @message[:value])
      response[:message] = "Ruby Rails service: successfully write to database"
    end

    response[:returnTime] = Time.current
    Rails.logger.info("Processed API message #{@message[:message]} at #{response[:returnTime]}")

    render json: response
  end

  private

    def set_message
      @message = {
        callTime: params[:callTime],
        target: params[:target],
        message: params[:message],
        key: params[:key],
        value: params[:value],
      }
    end

    def read_entity(store, key)
      case store
      when 'mysql'
        Mysql.find_by(uuid: key)
      else
        nil
      end
    end

    def write_entity(store, key, value)
      case store
      when 'mysql'
        Mysql.upsert({ uuid: key, content: value })
      else
        nil
      end
    end
end
