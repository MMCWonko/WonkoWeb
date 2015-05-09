      setUrlQueryParameter = (key, value) ->
        url = new URI(document.location.href)
        url.setQuery key, value
        if document.location.href != url.href()
          document.location.href = url.href()
        return

      hljs.initHighlightingOnLoad()
      $(document).on 'page:change', ->
        $('#getUrlLink').on 'click', ->
          prompt 'Ctrl+C followed by Enter', '#{api_v1_files_root_url}'
          # TODO: this should be the path to some CDN
          return
        $('#wurEnabler').bootstrapSwitch
          labelText: 'WUR'
          state: #{@wur_enabled ? 'true' : 'false'}
          onSwitchChange: (evt, state) ->
            if state == true
              bootbox.dialog
                message: 'This will enable the WonkoUserRepositories. This means you will see WonkoFiles and versions submitted by strangers that could potentially be malicious!'
                title: 'Enable the WUR?'
                buttons:
                  yes:
                    label: 'Yes'
                    className: 'btn-danger'
                    callback: ->
                      setUrlQueryParameter 'wur', true
                      return
                  no:
                    label: 'No'
                    className: 'btn-default'
                    callback: ->
                      $('#wurEnabler').click()
                      return
            else
              setUrlQueryParameter 'wur', false
            return
        return
