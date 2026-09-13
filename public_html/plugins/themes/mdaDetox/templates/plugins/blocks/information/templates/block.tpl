{**
 * plugins/themes/mdaDetox/templates/plugins/blocks/information/templates/block.tpl
 *
 * MDA Detox override of the bundled Information block.
 *
 * The stock block only prints a link when matching journal content exists,
 * which can leave the sidebar list uneven. This override always renders the
 * three standard Information links (For Readers, For Authors, For Librarians)
 * so the section matches the three links shown in the footer.
 *}
<div class="pkp_block block_information">
	<h2 class="title">{translate key="plugins.block.information.link"}</h2>
	<div class="content">
		<ul>
			<li>
				<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="readers"}">
					{translate key="navigation.infoForReaders"}
				</a>
			</li>
			<li>
				<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="authors"}">
					{translate key="navigation.infoForAuthors"}
				</a>
			</li>
			<li>
				<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="information" op="librarians"}">
					{translate key="navigation.infoForLibrarians"}
				</a>
			</li>
		</ul>
	</div>
</div>
