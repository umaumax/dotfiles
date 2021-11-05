  // key: title(label), value: node element
  var nodes_title_map = {}

  class target_nodes {
      constructor() {
          this.reset();
      }
      reset() {
          this.index = -1;
          this.nodes = [];
      }
      reset_index() {
          this.index = -1;
      }
      is_active() {
          return this.index != -1;
      }
      next() {
          if (this.index == -1) {
              this.index = 0;
              return;
          }
          if (this.nodes.length == 0) {
              return;
          }
          this.index++;
          if (this.index >= this.nodes.length) {
              this.index -= this.nodes.length;
          }
      }
      prev() {
          if (this.index == -1) {
              this.index = 0;
              return;
          }
          if (this.nodes.length == 0) {
              return;
          }
          this.index += this.nodes.length - 1;
          if (this.index >= this.nodes.length) {
              this.index -= this.nodes.length;
          }
      }
      get_target() {
          if (this.index < 0 || this.index >= this.nodes.length) {
              return null;
          }
          return this.nodes[this.index];
      }
      push(node) {
          this.nodes.push(node);
      }
  }

  var prev_nodes = new target_nodes();
  var next_nodes = new target_nodes();
  var clicked_node = null;
  var tooltip_display = true;

  function clearAllEdges(e) {
      var pathes = document.querySelectorAll('.edge path');
      pathes.forEach(function(path, i) {
          path.setAttribute('stroke', "black");
          path.setAttribute('stroke-width', "1px");
          path.setAttribute('stroke-opacity', "1.0");
      });
  }

  function clickNode(e, preset_prev_nodes = null, preset_next_nodes = null) {
      clicked_node = e;
      e.focus();
      e.scrollIntoView({
          behavior: 'smooth',
          block: 'center',
          inline: 'center'
      });
      if (tooltip_display) {
          showHelp();
      }
      var node = e.querySelector('title').textContent;
      prev_nodes.reset();
      next_nodes.reset();
      focus_target_index = -1;
      var titles = document.querySelectorAll('.edge title');
      titles.forEach(function(title, i) {
          var g = title.parentElement;
          var path = g.querySelector('path');
          if (title.textContent.startsWith(node)) {
              var next_node_title = title.textContent.split('->')[1]; // -> is &#45;&gt;
              var next_node = nodes_title_map[next_node_title];
              if (preset_next_nodes == null || preset_next_nodes.includes(next_node)) {
                  if (next_node != clicked_node) {
                      next_nodes.push(next_node);
                  }
                  path.setAttribute('stroke-width', "3px");
                  path.setAttribute('stroke-opacity', "1.0");
              }
          } else if (title.textContent.endsWith(node)) {
              var prev_node_title = title.textContent.split('->')[0]; // -> is &#45;&gt;
              var prev_node = nodes_title_map[prev_node_title];
              if (preset_prev_nodes == null || preset_prev_nodes.includes(prev_node)) {
                  if (prev_node != clicked_node) {
                      prev_nodes.push(prev_node);
                  }
                  path.setAttribute('stroke-width', "2px");
                  path.setAttribute('stroke-opacity', "1.0");
              }
          } else {
              path.setAttribute('stroke-width', "0.5px");
              path.setAttribute('stroke-opacity', "0.2");
          }
      });
  }

  function clickNodeInFocus() {
      var focus_elem = document.activeElement;
      if (focus_elem.classList.contains('node')) {
          clickNode(focus_elem);
          return true;
      }
      return false;
  }
  document.documentElement.onload = function() {
      var nodes = document.querySelectorAll('.node');
      nodes.forEach(function(node, i) {
          node.onclick = function(event) {
              event.stopPropagation();
              clickNode(this);
          };
          node.tabIndex = 0;
          var title = node.querySelector('title').textContent;;
          nodes_title_map[title] = node;
      });

      createHelpTooltip();

      var graphs = document.querySelectorAll('.graph');
      graphs.forEach(function(graph, i) {
          graph.onclick = function() {
              clearAllEdges(this);
          };
      });
  };

  function createHelpTooltip() {
      var graph0 = document.getElementById('graph0')

      var svgns = "http://www.w3.org/2000/svg";
      var tooltip = document.createElementNS(svgns, 'g');
      tooltip.setAttributeNS(null, 'id', 'tooltip');
      graph0.appendChild(tooltip);

      var rect = document.createElementNS(svgns, 'rect');
      rect.setAttributeNS(null, 'x', 0);
      rect.setAttributeNS(null, 'y', 0);
      rect.setAttributeNS(null, 'width', 256);
      rect.setAttributeNS(null, 'height', 172);
      rect.setAttributeNS(null, 'fill', 'gold');
      rect.setAttributeNS(null, 'fill-opacity', '0.6');
      rect.setAttributeNS(null, 'stroke', 'black');
      rect.setAttributeNS(null, 'stroke-width', '4');
      rect.setAttributeNS(null, 'stroke-linejoin', 'round');
      tooltip.appendChild(rect);

      var newText = document.createElementNS(svgns, "text");
      newText.setAttributeNS(null, "x", 0);
      newText.setAttributeNS(null, "y", 0);
      newText.setAttributeNS(null, "font-size", "16");
      newText.setAttributeNS(null, "color", "darkslategray");

      var text = "[❓HELP]\nn: next node\np: next(reverse) node\nN: back node\nP: back(reverse) node\nc: click\ns: go to standard position\nq: toggle help popup";
      text.split('\n').forEach(function(line, i) {
          var tspan = document.createElementNS(svgns, "tspan");
          tspan.setAttributeNS(null, "dx", '1.0em');
          tspan.setAttributeNS(null, "dy", String(1.4 + 1.2 * i) + 'em');
          var textNode = document.createTextNode(line);
          tspan.appendChild(textNode);
          newText.appendChild(tspan);
      });
      tooltip.appendChild(newText);
  }

  function showHelp() {
      if (!clicked_node) {
          return;
      }

      var tooltip = document.getElementById('tooltip');
      tooltip.style.display = 'block';

      x = clicked_node.querySelector('text').getAttribute('x') - 128;
      y = clicked_node.querySelector('text').getAttribute('y') - 256;

      tooltip.querySelectorAll('*').forEach(function(e, i) {
          e.setAttribute('x', x);
          e.setAttribute('y', y);
      });
  }

  function hideHelp() {
      var tooltip = document.getElementById('tooltip');
      tooltip.style.display = 'none';
  }

  function toggleHelp() {
      tooltip_display = !tooltip_display;
      if (tooltip_display) {
          showHelp();
      } else {
          hideHelp();
      }
  }

  window.addEventListener('keydown', function(event) {
      // console.log('keydown', event);
      var target_node = null;
      // n: next
      if (event.keyCode == 78 && !event.shiftKey) {
          next_nodes.next();
          target_node = next_nodes.get_target();
          prev_nodes.reset_index();
      }
      // p: prev
      if (event.keyCode == 80 && !event.shiftKey) {
          next_nodes.prev();
          target_node = next_nodes.get_target();
          prev_nodes.reset_index();
      }
      // N: Next of previous targets
      if (event.keyCode == 78 && event.shiftKey) {
          prev_nodes.next();
          target_node = prev_nodes.get_target();
          next_nodes.reset_index();
      }
      // P: Prev of previous targets
      if (event.keyCode == 80 && event.shiftKey) {
          prev_nodes.prev();
          target_node = prev_nodes.get_target();
          next_nodes.reset_index();
      }

      // ,: left
      if (event.keyCode == 188 && !event.shiftKey) {
          if (next_nodes.is_active()) {
              target_node = clicked_node;
          } else if (prev_nodes.is_active()) {
              if (clickNodeInFocus()) {
                  prev_nodes.next();
                  target_node = prev_nodes.get_target();
              }
          } else {
              prev_nodes.next();
              target_node = prev_nodes.get_target();
              clickNode(target_node, null, null);
              target_node = null;
          }
      }
      // .: right
      if (event.keyCode == 190 && !event.shiftKey) {
          if (next_nodes.is_active()) {
              if (clickNodeInFocus()) {
                  next_nodes.next();
                  target_node = next_nodes.get_target();
              }
          } else if (prev_nodes.is_active()) {
              target_node = clicked_node;
          } else {
              next_nodes.next();
              target_node = next_nodes.get_target();
              // clickNode(target_node, [clicked_node],null);
              // target_node=null;
          }
      }

      // s: go to standard node(last clicked node)
      if (event.keyCode == 83) {
          target_node = clicked_node;
      }

      if (target_node) {
          target_node.focus();
          target_node.scrollIntoView({
              behavior: 'smooth',
              block: 'center',
              inline: 'center'
          });
      }

      // c: click node in focus
      if (event.keyCode == 67) {
          var focus_elem = document.activeElement;
          if (focus_elem && focus_elem.classList.contains('node')) {
              clickNode(focus_elem);
          }
      }

      // q: click node in focus
      if (event.keyCode == 81) {
          toggleHelp();
      }
  }, true);
