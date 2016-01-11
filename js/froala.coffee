froalaTables = ->
  $('.js-wysiwyg').find('table').each ->
    $table = $(this)
    $rows  = null

    # A, B, C, D
    labels = $table.find('thead').find('th').map -> $(this).text()

    for label, index in labels
      $rows ||= $table.find('tbody').find('tr')

      for row in $rows

        # C1, C2, C3, C4
        # A,  B,  C,  D
        #
        # C1, C2, C34
        # A,  B,  C
        #
        $cells = $(row).find('td')

        for cell in $cells.slice(index)
          $(cell).attr('data-label', label)

if Turbolinks?
  $(document).on 'page:change', froalaTables
else
  $(document).on 'ready pjax:end', froalaTables