import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;

import java.io.ByteArrayInputStream;

public class VulnerableXXEExample {

    public static void main(String[] args) {
        String xml = """
                <?xml version="1.0"?>
                <!DOCTYPE data [
                    <!ENTITY xxe SYSTEM "file:///etc/passwd">
                ]>
                <user>
                    <name>&xxe;</name>
                </user>
                """;

        try {
            // CONFIGURAÇÃO VULNERÁVEL
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);

            DocumentBuilder builder = factory.newDocumentBuilder();

            Document document = builder.parse(
                    new ByteArrayInputStream(xml.getBytes())
            );

            // String result = document
                    .getElementsByTagName("name")
                    .item(0)
                    .getTextContent();

            logger.info("Conteúdo da entidade:");
            logger.info("Conteúdo da entidade:");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
