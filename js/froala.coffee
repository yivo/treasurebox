froalaTables = ->
  $('.js-wysiwyg').find('table').each ->
    $table = $(this)
    $rows  = null

    # A, B, C, D
    labels = []

    $table.find('> thead > tr > th').each -> labels.push($(this).text())

    # H1 H2
    # C1 C2 C3

    for label, index in labels
      $rows ||= $table.find('> tbody > tr')

      for row in $rows

        # C1, C2, C3, C4
        # A,  B,  C,  D
        #
        # C1, C2, C34
        # A,  B,  C
        #
        $cells = $(row).children(if index then "td:gt(#{index - 1})" else 'td')

        for cell in $cells
          $cell = $(cell)

          continue if parseInt($cell.attr('colspan')) == labels.length

          $label = $(cell).children('.cell-label')

          if $label[0]
            $label.text(label)
          else
            $(cell).html [
              '<div class="cell-label">',   label,        '</div>',
              '<div class="cell-content">', $cell.html(), '</div>',
              '<div class="clear"></div>'
            ].join('')

if Turbolinks?
  $(document).on 'page:change', froalaTables

else
  $(document).on 'ready pjax:end', froalaTables