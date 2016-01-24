###
 * Federated Wiki : Linkmap Plugin
 *
 * Licensed under the MIT license.
 * https://github.com/fedwiki/wiki-plugin-linkmap/blob/master/LICENSE.txt
###

fs = require 'fs'
url = require 'url'


startServer = (params) ->
  console.log 'linkmap startServer', (k for k,v of params)

  app = params.app
  server = params.server
  linkmap = {}

  asSlug = (name) ->
    name.replace(/\s/g, '-').replace(/[^A-Za-z0-9-]/g, '').toLowerCase()

  fetchPage = (path, done) ->
    text = fs.readFile path, 'utf8', (err, text) ->
      return console.log ['linkmap fetchPage error', path, err] if err
      done JSON.parse text

  findLinks = (page) ->
    unique = {}
    for item in page.story || []
      links = switch item?.type
        when 'paragraph' then item.text.match /\[\[([^\]]+)\]\]/g
      if links
        for link in links
          [match, title] = link.match /\[\[([^\]]+)\]\]/
          unique[asSlug title] = title
    slug for slug, title of unique

  buildmap = (pages) ->
    fs.readdir pages, (err, names) ->
      return if err or !names?.length
      for slug in names
        if slug.match /^[a-z0-9-]+$/
          do (slug) ->
            fetchPage "#{pages}/#{slug}", (page) ->
              linkmap[slug] = findLinks page

  host = url.parse(params.argv.url).hostname

  expressWs = require('express-ws')(app, server)

  buildmap params.argv.db

  app.ws "/plugin/linkmap/#{host}", (ws, req) ->
    console.log 'connection established, ready to send'
    ws.send JSON.stringify(linkmap, null, 2), (err) ->
      console.log 'unable to send ws message:', err if err

module.exports = {startServer}
