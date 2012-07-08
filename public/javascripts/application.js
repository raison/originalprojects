// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function($) {
  this.replace_id = function replace_id(s) {
    var new_id = new Date().getTime();
    return s.replace(/NEW_RECORD/g, new_id);
  };
  
  this.setupMultiFields = function (objName, formTemplate) {
    $('.delete_' + objName + '_field').hide().each(function () {
      var $checkbox = $(this).find('input[type="checkbox"]');
      $(this).after('<a class="delete_icon delete_' + objName +
        '" rel="' + $checkbox.attr('id') + '" href="#"><img src="/images/console/delete_icon.png" alt="delete" /></a>');
    });
    
    $('button#add_' + objName).click(function () {
      $('#' + objName + '_collection').append(replace_id(formTemplate));
      return false;
    });
    
    $('a.delete_' + objName).click(function () {
      var rel = $(this).attr('rel');
      $('#' + rel).attr('checked', true);
      $(this).parent('div.' + objName).hide();
      $(this).hide();
      return false;
    });        
  };
  
  $.fn.replyList = function() {
    return this.each(function() {
      var $container = $(this);
      var $link = $container.prev("p").find("a.reply_toggle");
      var $replies = $container.find("li");
      var $textarea = $container.find("textarea");

      if ($replies.size() > 0) {
        $link.click(function() {
          $textarea.focus();
          return false;
        });
      } else {
        $container.hide();
        $link.click(function() {
          $container.toggle();
          $textarea.focus();
          return false;
        });
      }
    });
  };

  $(document).ready(function () {
    $('.not_implemented').fadeTo(0, 0.75);
    $('.not_implemented *').css('cursor', 'wait');
    
    $('.not_implemented a, a.TODO').click(function () {
      alert("This functionality is not yet implemented.");
      return false;
    });
    
    $('.promo a').attr('target', '_blank');

    $(".search_terms").focus(function() { $(this).val(""); });

    $("#user_search").focus(function() {
      $(this).val("");
    })
    .autocomplete({
      ajax: "/profiles",
      match: function(typed) { return true; }
    })
    .parents("form").submit(function() {
      $.post(this.action, $(this).serialize(), function(src) {
        var $li = $(src).hide();
        $("#user_search").val("");
        $("#project_members").append($li);
        $li.fadeIn();
      });

      return false;
    });

    $("div.replies").replyList();

    $("a[rel=facebox]").facebox();

    $(this).bind('reveal.facebox', function() {
      Recaptcha.create(recaptcha_public_key, document.getElementById('dynamic_recaptcha'));
    });

    $("a.show_all_updates").click(function() {
      $link = $(this);

      $.get(this.href, function(src) {
        $("div#updates ul").append($(src));
      });

      $link.fadeOut();
      return false;
    });

    $("ul.project_filter").each(function() {
      var $links = $(this).find("a");
      var $content = $("div#my_projects > div");

      $links.click(function() {
        $links.removeClass("active");
        $(this).addClass("active");

        var section = this.href.split("#")[1];

        if ($.inArray(section, ["originated", "collaborating", "following"]) != -1) {
          $content.hide();
          $("div." + section).show();
        } else {
          $content.show();
        }

        return false;
      });

      $(this).find("." + location.hash.split("#")[1]).click();
    });

    $("input#invite_request_project").each(function() {
      if (!this.checked) {
        $("#description_container").hide();
      }

      $(this).click(function() {
        if (this.checked) {
          $("#description_container").show();
        } else {
          $("#description_container").hide();
        }
      });
    });
  });
})(jQuery);
