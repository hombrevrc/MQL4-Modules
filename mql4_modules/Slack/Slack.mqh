//+------------------------------------------------------------------+
//|                                                        Slack.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+


#ifndef _LOAD_MODULE_SLACK
#define _LOAD_MODULE_SLACK


/** Include header files */
#include <mql4_modules\Assert\Assert.mqh>
#include <mql4_modules\Web\Web.mqh>


/**  */
class Slack
{
   private:
      static string api_key;
   public:
      static void setAPIKey(const string value);
      static bool send(const string text, string channel = "general");
};


/** @param string api_key  Slack API token. */
static string Slack::api_key = "";


/**
 * api_key's setter.
 *
 * @param const string value  Value of the slack api token.
 */
static void Slack::setAPIKey(const string value)
{
   Slack::api_key = value;
}


/**
 * Method for posting to slack.
 *
 * @param string text  Contents to post on slack.
 * @param string channel  Posting slack channel.
 *
 * @return bool  Returns true if successful, otherwise false.
 */
static bool Slack::send(const string text, string channel = "general")
{
   assert(StringLen(Slack::api_key) > 0, "check the slack api key.");
   
   string url = "https://slack.com/api/chat.postMessage";
   string response;
   
   Web::addParameter("token", Slack::api_key);
   Web::addParameter("channel", "%23" + channel);
   Web::addParameter("text", text);
   
   Web::get(url, response);
   
   return(StringFind(response, "\"ok\":true", 0) != -1);
}


#endif
