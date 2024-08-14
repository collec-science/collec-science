(function ($) {
    var FolderTree = function (options) {
        this.container = $('#FolderTree');
        this.contentContainer = $('#FileList');
        this.crumbContainer = $('#FolderCrumb');
        this.script = 'getfiles';
        this.fileScript = 'getfile';
        this.root = '/';
        this.rootLabel = '/';
        this.roots = [];
        $.extend(this, options);
        this.rootNode = new FolderNode({ path: this.root, hasSubfolder: true, isFolder: true, label: this.rootLabel, tree: this });
        if (typeof options.container == 'string') {
            this.container = $(options.container);
        }
        if (typeof options.contentContainer == 'string') {
            this.contentContainer = $(options.contentContainer);
        }
        if (typeof options.crumbContainer == 'string') {
            this.crumbContainer = $(options.crumbContainer);
        }
        this.selectedNode = null;
    };
    FolderTree.prototype.Show = function () {
        if (!this.element) {
            this.element = this.container;
        }
        var $this = this;
        this.rootNode.GetChildren(function () {
            for (var i = 0; i < $this.rootNode.children.length; i++) {
                $this.rootNode.children[i].Show();
            }
            $this.rootNode.ShowContent($this.contentContainer, $this.crumbContainer);
        });
    };
    FolderTree.prototype.OnSelect = function (callback) {
        this._onSelect = callback;
    };
    /*
    options:
    {
        label: string (e.g.: 'folder1' or 'pic.jpg')
        ext: string (e.g.: 'jpg'):
        path: string (e.g.: 'C:/Windows' or 'C:/Temp/pic.jpg')
        isFolder: bool
        isDrive: bool
        hasSubfolder: bool
        subitems:array of string (e.g.: ['1/1/2021', '100,000'])
    }
     */
    var FolderNode = function (options) {
        this.data = {};
        this.indent = 10;
        this.parent = null;
        this.label = null;
        this.collapsed = true;
        this.element = null;
        this.tree = null;
        this.selected = false;
        $.extend(this, options);
        this.children = [];
        this.subfolders = [];
        this.files = [];
        if (options.children != undefined) {
            for (var i = 0; i < options.children.length; i++) {
                this.AddChild(new FolderNode(options.children[i]));
            }
        }
    };

    FolderNode.prototype.Show = function () {
        var expander, icon, label;
        this.element = $("<div>").addClass("foldertree-node");
        if (this.parent && this.parent.element) {
            this.parent.element.append(this.element);
            this.element.css('margin-left', this.indent);
        }
        else {
            this.tree.element.append(this.element);
        }
        expander = $("<span class='foldertree-expander'>");
        icon = $("<span class='foldertree-icon'></span>");
        icon.addClass(this.isDrive ? "drive-icon" : "foldertree-icon-collapsed");

        label = $("<span class='foldertree-label'>").text(this.label);
        this.element.append(expander)
            .append(icon)
            .append(label);
        this.element.data("node", this);
        if (this.hasSubfolder) {
            expander.addClass("foldertree-expander-collapsed");
        }
        this.element.show();
        expander.off("click").on("click", function () {
            node = $(this).closest("div").data('node');
            if (node.collapsed) node.Expand();
            else node.Collapse();
        })
        label.off("click").on("click", function () {
            node = $(this).closest("div").data('node');
            node.Select();
        })
    };

    FolderNode.prototype.GetChildren = function (callback) {
        var $this = this;
        this.script = this.script || this.tree.script;
        this.fileScript = this.fileScript || this.tree.fileScript;
        var handleResult = function (result) {
            $this.children = [];
            $this.files = [];
            $this.subfolders = [];
            for (var i = 0; i < result.length; i++) {
                if (result[i].isFolder) {
                    result[i].script = result[i].script || $this.script;
                    $this.AddChild(new FolderNode(result[i]));
                    $this.subfolders.push(result[i]);
                }
                else {
                    result[i].script = result[i].script || $this.fileScript;
                    $this.files.push(result[i]);
                }
            }
        };
        var handleFail = function () {

        };
        var data = {
            path: this.path
        };
        if (typeof this.script == 'function') {
            handleResult(this.script(data));
            callback && callback();
        }
        else if (typeof this.script == 'string') {
            $.ajax({
                url: this.script,
                type: 'POST',
                dataType: 'json',
                data: data,
            }).done(function (result) {
                handleResult(result);
                callback && callback();
            }).fail(function () {
                handleFail();
                callback && callback({ error: 1 });
            });
        }
    };

    FolderNode.prototype.AddChild = function (childNode) {
        childNode.parent = this;
        childNode.tree = this.tree;
        this.children.push(childNode);
        return childNode;
    };
    FolderNode.prototype.Expand = function () {
        $this = this;
        $this.element.children(".foldertree-expander").removeClass("foldertree-expander-collapsed").addClass("waiting");
        this.GetChildren(function (error) {
            if (!error) {
                for (var i = 0; i < $this.children.length; i++) {
                    $this.children[i].Show();
                }
            }
            else {
                $this.element.append("<div class='foldertree-node foldertree-error'>Failed to retrieve folder content</div>");
            }
            $this.element.children(".foldertree-expander").removeClass("waiting").addClass("foldertree-expander-expanded");
            if (!$this.icon) {
                $this.element.children(".foldertree-icon.foldertree-icon-collapsed").removeClass("foldertree-icon-collapsed").addClass("foldertree-icon-expanded");
            }
            $this.collapsed = false;

        });
    };
    FolderNode.prototype.Collapse = function () {
        this.element.find(".foldertree-node").remove();
        this.children = [];
        this.element.children(".foldertree-expander").addClass("foldertree-expander-collapsed").removeClass("foldertree-expander-expanded");
        if (!this.icon) {
            this.element.children(".foldertree-icon.foldertree-icon-expanded").removeClass("foldertree-icon-expanded").addClass("foldertree-icon-collapsed");
        }

        this.collapsed = true;
    };
    FolderNode.prototype.OnSelect = function (callback) {
        this._onSelect = callback;
    };
    FolderNode.prototype.Select = function () {
        $(".foldertree-node-selected").removeClass("foldertree-node-selected");
        this.element.addClass("foldertree-node-selected");
        this.selected = true;
        if (this.tree) {
            if (this.tree.selectedNode) {
                this.tree.selectedNode.selected = false;
            }
            this.tree.selectedNode = this;
        }
        this.ShowContent(this.tree.contentContainer, this.tree.crumbContainer);

        if (this._onSelect != undefined) {
            this._onSelect(this);
        }
        if (this.tree._onSelect != undefined) {
            this.tree._onSelect(this);
        }
    };
    FolderNode.prototype.GetCrumbs = function () {
        if (!this.parent) {
            return [this];
        }
        else {
            return this.parent.GetCrumbs().concat([this]);
        }
    }
    FolderNode.prototype.ShowCrumbs = function (crumbContainer, contentContainer) {
        $(crumbContainer).children().remove();
        var crumbs = this.GetCrumbs();
        for (var i = 0; i < crumbs.length - 1; i++) {
            $("<span>").addClass("folder-crumb").text(crumbs[i].label).data('node', crumbs[i]).on("click", function (e) {
                $(e.target).data('node').ShowContent(contentContainer, crumbContainer);
            }).appendTo($(crumbContainer));
            $(crumbContainer).append($("<span>").addClass("folder-crumb-separator"));
        }
        $(crumbContainer).append($("<span>").addClass("folder-crumb").text(this.label));
        $(crumbContainer).scrollLeft($(crumbContainer)[0].scrollWidth);
    }
    FolderNode.prototype.ShowContent = function (contentContainer, crumbContainer, message) {
        var contentElem;
        if (typeof contentContainer == 'string') {
            contentElem = $(contentContainer);
        }
        else {
            contentElem = contentContainer;
        }
        if (!contentElem) return;
        if ($(crumbContainer)) {
            this.ShowCrumbs(crumbContainer, contentContainer);
        }
        contentElem.children().remove();
        contentElem.addClass('waiting');
        if (message) {
            $("<span>").addClass('foldertree-error').text(message).appendTo(contentElem);
            return;
        }
        var $this = this;
        this.GetChildren(function (error) {
            contentElem.removeClass('waiting');
            if (error) {
                $("<span>").addClass('foldertree-error').text("Failed to get folder content.").appendTo(contentElem);
                return;
			}
			var children=$this.subfolders.concat($this.files);
			$.each(children,function(index,child){
                var item = $("<div>").addClass("foldercontent-item");
                var icon = $("<span class='foldercontent-icon'>");
                icon.addClass(child.isDrive ? "drive-icon" : (child.isFolder ? "foldertree-icon-collapsed" : "file-icon ext-" + child.ext));
                var label = $("<span class='foldercontent-label'>").text(child.label);
                label.data("data", child);
                label.off("click").on("click", function (e) {
					var data=$(e.target).data('data');
					if(data.isFolder)
					{
						var newNode = new FolderNode(data);
						newNode.script = newNode.script || $this.script;
						newNode.fileScript = newNode.fileScript || $this.fileScript;
						newNode.parent = $this;
						newNode.ShowContent(contentContainer, crumbContainer);
					}
					else
					{
						if (typeof $this.fileScript=='function') {
							$this.fileScript(data);
						}
						else if(typeof  $this.fileScript=='string') {
                            /**
                             * Change E. Quinton for Metabo
                             * Initial:
                             * window.open($this.fileScript+"?path="+data.path);
                             */
							window.open($this.fileScript+"&path="+data.path, "_self");
						}
					}
                });
				item.append(icon).append(label);
				if(child.subitems)
				{
					$.each(child.subitems,function(index,text){
						var subitem=$("<span>").addClass("foldercontent-subitem").addClass("foldercontent-subitem-"+index).text(text);
						item.append(subitem);
					})
				}
                contentElem.append(item);
			});
        });
    }
    FileExplorer = function (options) {
        if (!options.container) return;
        var container = $(options.container);
        container.addClass("fileexplorer");
        container.children().remove();
        var crumbs = $("<div>").addClass("foldercrumbs");
        var explorer = $("<div>").addClass("fileexplorer-content");
        var foldertree = $("<div>").addClass("foldertree");
        var foldercontent = $("<div>").addClass("foldercontent");
        container.append(crumbs).append(explorer.append(foldertree).append(foldercontent));
        if (typeof Split == "function") {
            Split([foldertree[0], foldercontent[0]], {
                sizes: [25, 75],
                direction: 'horizontal',
                cursor: 'col-resize',
                gutterSize: 5,
            });
        }
        var tree = new FolderTree({
            container: foldertree,
            crumbContainer: crumbs,
            contentContainer: foldercontent,
            script: options.script,
            fileScript: options.fileScript,
            root: options.root || "/",
            rootLabel: options.rootLabel || "/"
        });
        tree.Show();
    }
    $.fn.extend({
        jQueryFileExplorer: function (options) {
            options.container = this;
            FileExplorer(options)
        }
    });
})($);
