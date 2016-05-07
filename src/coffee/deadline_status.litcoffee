# deadline_status test

    $(document).ready ->
      $.ajax(
        url: "http://api.example.com"
      ).then (data) ->
        alert(data)
