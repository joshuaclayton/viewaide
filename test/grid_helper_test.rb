require "test_helper"

class GridHelperTest < Viewaide::ViewTestCase

  context "advanced grid structures" do

    should "properly assign classes for a simple column layout" do
      template = %(
        <% container do %>
          <% column do %>
            <% column :half, :id => "primary" do %>
              <% column :one_third do %>
                one third of one half of 24 is 4
              <% end %>
              <% column :one_third, :last, prepend_one_third do %>
                one third of one half of 24 is 4 (but prepended 4 as well)
              <% end %>
              <hr/>
              more text
            <% end %>
            <% column :half, :last, :id => "secondary" do %>
              second column
            <% end %>
            <hr/>
            text
          <% end %>
        <% end %>
      )

      show_view template do
        assert_select ".container", 1
        assert_select ".container.span-24", 0
        assert_select ".span-24", 1
        assert_select ".span-12", 2
        assert_select ".span-12#primary", 1
        assert_select ".span-12#secondary", 1
        assert_select ".span-4", 2
        assert_select ".prepend-4", 1
        assert_select ".span-24.last", 0
        assert_select ".span-12.last", 1
        assert_select ".span-4.last", 1
        assert_select "hr", 2
      end
    end

    should "properly assign classes for generic helpers" do
      template = %(
        <% column do %>
          <% recordset :simple, :half do %><% end %>
          <% recordset :half, :last do %>table content<% end %>
        <% end %>
      )

      show_view template do
        assert_select "div.span-24" do
          assert_select "table.simple.span-12"
          assert_select "table.span-12.last", "table content"
        end
      end
    end

    should "properly assign classes for generic helpers without column wrappers" do
      template = %(
        <% recordset :hform, :half do %>
          <% column do %>
            <% column :one_third do %>one third<% end %>
            <% column :two_thirds, :last do %>
              <% column :half do %>half<% end %>
              <% column :half, :last do %>last half<% end %>
            <% end %>
          <% end %>
        <% end %>
        <% column :one_third do %>
          <% column :one_fourth do %>two wide<% end %>
          <% column :half do %>four wide<% end %>
          <% column :one_fourth, :last do %>two more wide<% end %>
        <% end %>
        <% recordset :one_sixth, :last do %>table<% end %>
      )

      show_view template do
        assert_select "table.hform.span-12" do
          assert_select "div.span-12.last" do
            assert_select "div.span-4", "one third"
            assert_select "div.span-8.last" do
              assert_select "div.span-4", "half"
              assert_select "div.span-4.last", "last half"
            end
          end
        end
        assert_select "div.span-8" do
          assert_select "div.span-2", "two wide"
          assert_select "div.span-4", "four wide"
          assert_select "div.span-2.last", "two more wide"
        end
        assert_select "table.span-4.last", "table"
      end
    end

    should "properly assign classes for a deeply-nested view" do
      template = %(
        <% container :full do %>
          <% column :half do %>
            <% recordset :hform, :half do %>
              <% column :one_third do %>text<% end %>
              <% column :two_thirds, :last do %>more text<% end %>
            <% end %>
            <% recordset :half, :last do %>table<% end %>
          <% end %>
          <% column :one_third do %>one third!<% end %>
          <% column :one_sixth, :last do %>
            <% recordset :vform, :full do %>
              <% column do %>text<% end %>
            <% end %>
          <% end %>
        <% end %>
      )

      show_view template do
        assert_select "div.container.span-24", 1
        assert_select "div.container" do
          assert_select "div.span-12" do
            assert_select "table.hform.span-6" do
              assert_select "div.span-2", "text"
              assert_select "div.span-4.last", "more text"
            end
            assert_select "table.span-6.last", "table"
          end

          assert_select "div.span-8", "one third!"

          assert_select "div.span-4.last" do
            assert_select "table.vform.span-4.last" do
              assert_select "div", "text"
            end
          end
        end
      end
    end

    should "properly assign classes when using Easel grid" do
      template = %(
        <% container do %>
          <% column do %>
            <% column :half, :id => "primary" do %>
              <% column :one_third do %>
                one third of one half of 24 is 4
              <% end %>
              <% column :one_third, :last, prepend_one_third do %>
                one third of one half of 24 is 4 (but prepended 4 as well)
              <% end %>
              <hr/>
              more text
            <% end %>
            <% column :half, :last, :id => "secondary" do %>
              second column
            <% end %>
            <hr/>
            text
          <% end %>
        <% end %>
      )
      Viewaide::Helpers::GridHelper.easel_grid!
      show_view template do
        assert_select ".container", 1
        assert_select ".col-24", 1
        assert_select ".col-12", 2
        assert_select ".col-12#primary", 1
        assert_select ".col-12#secondary", 1
        assert_select ".col-4", 2
        assert_select ".prepend-4", 1
        assert_select ".col-24.col-last", 0
        assert_select ".col-12.col-last", 1
        assert_select ".col-4.col-last", 1
        assert_select "hr", 2
      end
      Viewaide::Helpers::GridHelper.blueprint_grid!
    end
  end

  context "column" do

    should "allow assigning options hash without having to define a width" do
      show_view %(
        <% column :id => "my-custom-id", :class => "content" do %>words<% end %>
      ) do
        assert_select "div.span-24.content#my-custom-id", "words"
      end
    end

    should "allow explicit column assignment" do
      show_view %(
        <% column 6, :sidebar do %>
          <% column :id => "main" do %>main sidebar<% end %>
          <% column :half do %>three<% end %>
          <% column :one_third do %>two<% end %>
          <% column 1, :last do %>one<% end %>
        <% end %>
      ) do
        assert_select "div.span-6.sidebar" do
          assert_select "div.span-6.last#main", "main sidebar"
          assert_select "div.span-3", "three"
          assert_select "div.span-2", "two"
          assert_select "div.span-1.last", "one"
        end
      end
    end

    should "allow tag overriding" do
      show_view %(<% column :tag => :section do %>content<% end %>) do
        assert_select "section.span-24:not([tag=section])", "content"
      end
    end
  end
end
